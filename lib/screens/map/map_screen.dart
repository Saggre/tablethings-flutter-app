import 'dart:async';
import 'dart:ui';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/layered_button_group/layered_button_group.dart';
import 'package:tablething/components/layered_button_group/menus/tabbed_food_menu.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/cuisine_types.dart';
import 'package:tablething/screens/map/components/establishment_info_popup.dart';
import 'package:tablething/screens/qr_scan/qr_scan_screen.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:latlong/latlong.dart' as Latlong;
import 'package:flutter/services.dart' show rootBundle;
import 'package:tablething/util/text_factory.dart';

class MapScreen extends StatefulWidget {
  final bool isFullScreenDialog;

  MapScreen({Key key, this.isFullScreenDialog = false}) : super(key: key);

  @override
  MapScreenState createState() {
    return MapScreenState();
  }
}

/// Data for the establishment popup
class MapScreenEstablishmentPopupOptions {
  Establishment establishment;
  bool visible = false;
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Map<Establishment, Marker> _mapMarkers = Map();

  // The establishment to show as a popup
  MapScreenEstablishmentPopupOptions _establishmentPopup = MapScreenEstablishmentPopupOptions();

  /// JSON Google map style
  String _mapStyle;

  @override
  void initState() {
    super.initState();

    // Load map style JSON
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });
  }

  /// Checks if the list of map markers contains a marker with markerIdValue
  bool _containsMarker(Establishment establishment) {
    return _mapMarkers.containsKey(establishment);
  }

  /// Adds a marker to the map
  void _addMarker(Establishment establishment) async {
    if (_containsMarker(establishment)) {
      return;
    }

    print("Adding new marker for an establishment: " + establishment.name);

    // Get icon
    // TODO what if error
    BitmapDescriptor icon =
        await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), establishment.getDefaultCuisineTypeDescription().iconPath);

    MarkerId markerId = MarkerId(establishment.id);

    // creating a new MARKER
    final Marker marker = Marker(
      icon: icon,
      markerId: markerId,
      position: LatLng(establishment.location.latitude, establishment.location.longitude),
      onTap: () {
        _onMarkerTapped(establishment);
      },
    );

    _mapMarkers[establishment] = marker;
  }

  /// When a marker is selected / tapped
  void _onMarkerTapped(Establishment establishment) {
    print('Tapped marker');
    _showEstablishmentPopup(establishment);
  }

  /// Show a dialog containing information about the marker
  void _showEstablishmentPopup(Establishment establishment) {
    setState(() {
      _establishmentPopup.establishment = establishment;
      _establishmentPopup.visible = true;
    });
  }

  /// Get's a popup widget containing info about an establishment
  Widget _getEstablishmentPopupWidget() {
    if (!_establishmentPopup.visible || _establishmentPopup.establishment == null) {
      return Container();
    }

    return EstablishmentInfoPopup(
      establishment: _establishmentPopup.establishment,
    );
  }

  /// Moves the map to a certain coordinate
  void _moveMapToLatLng(Latlong.LatLng position, {bool instantMove = false}) async {
    // Translate to map coordinates
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
  void _refreshMarkersInArea() async {
    print("Refreshing markers in currently visible area");

    final GoogleMapController controller = await _controller.future;
    LatLngBounds mapBounds = await controller.getVisibleRegion();

    // Get establishments inside the bounds from database
    BlocProvider.of<MapBloc>(context).add(GeoAreaMapBlocEvent(
      Latlong.LatLng(mapBounds.northeast.latitude, mapBounds.northeast.longitude),
      Latlong.LatLng(mapBounds.southwest.latitude, mapBounds.southwest.longitude),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var lightButtonTextStyle = TextFactory.buttonStyle.copyWith(color: Colors.black, shadows: [
      Shadow(
        blurRadius: 5.0,
        color: Color(0x11000000),
        offset: Offset(0.0, 0.0),
      ),
    ]);

    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _getMap(),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LayeredButtonGroup(
                    onTap: () {
                      print('Opening QR-code scanner');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRScanScreen()),
                      );
                    },
                    buttonText: t('Scan and eat'),
                    subMenu: TabbedFoodMenu(
                      firstTabOptions: TabbedMenuOptions(
                        truncated: Text(
                          t('...'),
                          style: TextFactory.buttonStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                        expanded: Text(
                          t('Categories'),
                          style: TextFactory.buttonStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      secondTabOptions: TabbedMenuOptions(
                        truncated: TextFactory.getCuisineIcon(CuisineType.other, width: 24, height: 24),
                        expanded: Text(
                          t('Restaurants'),
                          style: lightButtonTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      thirdTabOptions: TabbedMenuOptions(
                        truncated: TextFactory.getCuisineIcon(CuisineType.coffee, width: 24, height: 24),
                        expanded: Text(
                          t('Cafés'),
                          style: lightButtonTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      fourthTabOptions: TabbedMenuOptions(
                        truncated: TextFactory.getCuisineIcon(CuisineType.beer, width: 24, height: 24),
                        expanded: Text(
                          t('Bars'),
                          style: lightButtonTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MainAppBar(),
            _getEstablishmentPopupWidget(),
          ],
        ),
      ),
    );
  }

  double _minUpdateDist = 100.0; // Moves to user if GPS update is at least minUpdateDist meters away
  Latlong.LatLng _userLastPosition = Latlong.LatLng(0, 0);
  int _timesUpdatedUserLocation = 0; // First update teleports and later ones are smooth. Can also be used to identify when a map loader has to be shown

  Widget _getMap() {
    return BlocBuilder<MapBloc, MapBlocState>(
      builder: (context, state) {
        if (state is UserMovedMapBlocState) {
          // Move map to user location after map create
          double distance = Latlong.Distance().distance(_userLastPosition, state.userLocation).toDouble();
          print("Dist: " + distance.toString());
          if (distance >= _minUpdateDist || _timesUpdatedUserLocation == 0) {
            _userLastPosition = state.userLocation;
            _refreshMarkersInArea(); // Refresh markers when moved to a new area
            _timesUpdatedUserLocation++;

            // When map is initially set, it uses map widget's initialCameraPosition proeprty
            if (_timesUpdatedUserLocation > 0) {
              _moveMapToLatLng(_userLastPosition);
            }
          }
        }

        if (state is GeoAreaMapBlocState) {
          List<Establishment> establishments = state.establishments;

          debugPrint(state.establishments.length.toString() + " establishments in area");

          establishments.forEach((establishment) {
            // Create marker with establishment id
            _addMarker(establishment);
          });
        }

        // TODO map loader
        if (_timesUpdatedUserLocation == 0) {
          return Container(color: Colors.pink);
        }

        return GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(_userLastPosition.latitude, _userLastPosition.longitude),
            zoom: 12,
          ),
          mapToolbarEnabled: false,
          padding: EdgeInsets.only(bottom: 130, left: 5),
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
          onCameraIdle: () async {
            // Set markers when map stops moving
            _refreshMarkersInArea();
          },
          markers: Set<Marker>.of(_mapMarkers.values),
        );
      },
    );
  }
}
