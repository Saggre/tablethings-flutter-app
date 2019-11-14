import 'dart:async';
import 'dart:ui';
import 'package:location/location.dart';
import 'package:tablething/services/establishment.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/custom_app_bar.dart';
import 'package:latlong/latlong.dart' as Latlong;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:bloc/bloc.dart';

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

    // TODO is this the right thing to do?
    debugPrint("Start GPS");
    BlocProvider.of<UserLocationBloc>(context).add(UserLocationEvent.startGPS);

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
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    } else {
      controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
      appBar: CustomAppBar(),
      body: Stack(
        children: <Widget>[
          _getMap(),
          Column(
            children: <Widget>[
              BlocBuilder<UserLocationBloc, Latlong.LatLng>(builder: (context, Latlong.LatLng state) {
                String text = "Waiting...";

                if (state != null) {
                  text = 'Lat: ' + state.latitude.toString() + ' / Lon: ' + state.longitude.toString();
                }

                return Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  bool _initiallyMovedToUserLocation = false;

  Widget _getMap() {
    return BlocBuilder<EstablishmentsGeoBloc, EstablishmentsGeoBlocState>(
      builder: (context, state) {
        // Establishments bloc builder

        List<Establishment> establishments = state.establishments;
        establishments.forEach((establishment) {
          // Create marker with establishment id
          MarkerId markerId = MarkerId(establishment.id);
          if (!_containsMarker(markerId)) {
            debugPrint("Adding new marker for an establishment");
            _addMarker(establishment.location, markerId, establishment.getDefaultCuisineTypeDescription().iconPath);
          }
        });

        // End establishments bloc builder

        return GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);

            // Move map to user location after map create
            LocationData locationData = await _location.getLocation();
            var userLocation = Latlong.LatLng(locationData.latitude, locationData.longitude);
            // TODO what if getting user location fails

            _moveMapToLatLng(userLocation, instantMove: true);

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
