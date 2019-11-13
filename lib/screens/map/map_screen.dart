import 'dart:async';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/custom_app_bar.dart';
import 'package:latlong/latlong.dart' as Latlong;
import 'package:flutter/services.dart' show rootBundle;

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

  Marker _getMarkerWithId(String markerIdValue) {}

  /// Updates a marker with its id
  void _updateMarker(Latlong.LatLng position, MarkerId markerId) {
    if (_containsMarker(markerId)) {
      debugPrint("Moving marker");

      // Move the marker by removing the old one (this will liekly be updated in future gmap versions)
      _mapMarkers[markerId] = _mapMarkers[markerId].copyWith(positionParam: LatLng(position.latitude, position.longitude));
    }
  }

  /// Adds a marker to the map
  void _addMarker(Latlong.LatLng position, MarkerId markerId) {
    // creating a new MARKER
    final Marker marker = Marker(
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
  Future<void> _moveMapToLatLng(Latlong.LatLng position) async {
    // Translate to map coords
    LatLng mapPosition = LatLng(position.latitude, position.longitude);

    // Create gmap camera position
    CameraPosition cameraPosition = CameraPosition(
      target: mapPosition,
      zoom: 14.4746,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
              FlatButton(
                onPressed: () {
                  BlocProvider.of<UserLocationBloc>(context).add(UserLocationEvent.startGPS);
                },
                child: Text(
                  "Start tracking",
                ),
              ),
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

  Widget _getMap() {
    return BlocBuilder<UserLocationBloc, Latlong.LatLng>(
      builder: (context, Latlong.LatLng state) {
        MarkerId userMarkerId = MarkerId("me");

        if (state != null) {
          if (!_containsMarker(userMarkerId)) {
            _addMarker(state, userMarkerId);
          } else {
            _updateMarker(state, userMarkerId);
          }

          // Check if map controller is ready
          if (_controller.isCompleted) {
            _moveMapToLatLng(state);
          }
        }

        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
          markers: Set<Marker>.of(_mapMarkers.values),
        );
      },
    );
  }
}
