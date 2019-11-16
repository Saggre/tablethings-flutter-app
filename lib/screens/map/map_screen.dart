import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:tablething/components/raised_gradient_button.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/screens/qr_scan/qr_scan_screen.dart';
import 'package:tablething/services/establishment.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/custom_app_bar.dart';
import 'package:latlong/latlong.dart' as Latlong;
import 'package:flutter/services.dart' show ByteData, rootBundle;

class MapScreen extends StatefulWidget {
  final bool isFullScreenDialog;

  MapScreen({Key key, this.isFullScreenDialog = false}) : super(key: key);

  @override
  MapScreenState createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> _mapMarkers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  var _location = Location();

  /// JSON Google map style
  String _mapStyle;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();

    // Load map style JSON
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  /// Checks if the list of map markers contains a marker with markerIdValue
  bool _containsMarker(MarkerId markerId) {
    return _mapMarkers.containsKey(markerId);
  }

  /// Updates a marker with its id
  void _updateMarker(Latlong.LatLng position, MarkerId markerId) {
    if (_containsMarker(markerId)) {
      debugPrint("Moving marker");

      // Move the marker by removing the old one (this will likely be updated in future gmap versions)
      _mapMarkers[markerId] = _mapMarkers[markerId].copyWith(positionParam: LatLng(position.latitude, position.longitude));
    }
  }

  /// Adds a marker to the map
  void _addMarker(Latlong.LatLng position, MarkerId markerId, String iconPath) async {
    // Get icon
    // TODO what if error
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), iconPath);

    // creating a new MARKER
    final Marker marker = Marker(
      icon: icon,
      markerId: markerId,
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: markerId.value, snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );

    _mapMarkers[markerId] = marker;
  }

  /// Moves the map to a certain coordinate
  void _moveMapToLatLng(Latlong.LatLng position, {bool instantMove = false}) async {
    // Translate to map coords
    LatLng mapPosition = LatLng(position.latitude, position.longitude);

    // Create gmap camera position
    CameraPosition cameraPosition = CameraPosition(
      target: mapPosition,
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;

    // Animate or teleport
    if (instantMove) {
      controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } else {
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  /// Sends an event to get establishments in the currently visible map area
  void _refreshGeoArea() async {
    debugPrint("Refreshing geo area");

    final GoogleMapController controller = await _controller.future;
    LatLngBounds mapBounds = await controller.getVisibleRegion();

    // Translate google map coords to generic LatLng
    var event = EstablishmentsGeoBlocEvent(Latlong.LatLng(mapBounds.northeast.latitude, mapBounds.northeast.longitude),
        Latlong.LatLng(mapBounds.southwest.latitude, mapBounds.southwest.longitude));

    // Get establishments inside the bounds from database
    BlocProvider.of<EstablishmentsGeoBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _getMap(),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedGradientButton(
                  text: t('Scan and eat'),
                  iconData: Icons.fastfood,
                  gradient: buttonGradient,
                  onPressed: () {
                    print('Opening QR-code scanner');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScanScreen()),
                    );
                  },
                )
              ],
            ),
          ),
          CustomAppBar(),
        ],
      ),
    );
  }

  Widget _getMap() {
    return BlocBuilder<EstablishmentsGeoBloc, EstablishmentsGeoBlocState>(
      builder: (context, state) {
        // Establishments bloc builder

        List<Establishment> establishments = state.establishments;

        debugPrint(state.establishments.length.toString() + " establishments in area");

        establishments.forEach((establishment) {
          // Create marker with establishment id
          MarkerId markerId = MarkerId(establishment.id);
          if (!_containsMarker(markerId)) {
            debugPrint("Adding new marker for an establishment: " + establishment.name);
            _addMarker(establishment.location, markerId, establishment.getDefaultCuisineTypeDescription().iconPath);
          }
        });

        // End establishments bloc builder

        return GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          mapToolbarEnabled: false,
          padding: EdgeInsets.only(bottom: 65, left: 5),
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);

            double minUpdateDist = 100.0; // Moves to user if GPS update is at least minUpdateDist meters away
            Latlong.LatLng userOriginalPosition = Latlong.LatLng(0, 0);
            int timesUpdatedUserLocation = 0; // First update teleports and later ones are smooth

            // Move map to user location after map create
            _locationChanged(LocationData newLocation) {
              Latlong.LatLng newLatLng = Latlong.LatLng(newLocation.latitude, newLocation.longitude);
              double distance = Latlong.Distance().distance(userOriginalPosition, newLatLng).toDouble();
              print("Dist: " + distance.toString());
              if (distance >= minUpdateDist) {
                userOriginalPosition = newLatLng;
                _moveMapToLatLng(newLatLng, instantMove: timesUpdatedUserLocation == 0);
                timesUpdatedUserLocation++;
              }
            }

            // Initial location get
            _location.getLocation().then((location) {
              _locationChanged(location);
            });

            // Listen to location changes
            _location.onLocationChanged().listen((LocationData event) {
              _locationChanged(event);
            });

            // Set markers after map create
            _refreshGeoArea();
          },
          onCameraIdle: () async {
            // Set markers when map stops moving
            _refreshGeoArea();
          },
          markers: Set<Marker>.of(_mapMarkers.values),
        );
      },
    );
  }
}
