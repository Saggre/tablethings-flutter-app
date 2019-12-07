import 'dart:async';
import 'dart:ui';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/layered_button_group/layered_button_group.dart';
import 'package:tablething/components/layered_button_group/menus/tabbed_food_menu.dart';
import 'package:tablething/components/login_popup.dart';
import 'package:tablething/components/popup_widget.dart';
import 'package:tablething/components/transparent_route.dart';
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
import 'package:flutter/services.dart' show rootBundle;
import 'package:tablething/util/text_factory.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

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

  /// JSON Google map style
  String _mapStyle;

  @override
  void initState() {
    super.initState();

    // Load map style JSON
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyle = string;
    });

    () async {
      await Future.delayed(Duration.zero);

      void closeLoginPopup() {
        Navigator.of(context).pop();
      }

      Navigator.of(context).push(
        TransparentRoute(
          builder: (BuildContext context) => PopupWidget(
            child: LoginPopup(
              onCloseTapped: () => closeLoginPopup(),
            ),
            onCloseTapped: () => closeLoginPopup(),
          ),
        ),
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _getMap(),
            _getButtons(),
            MainAppBar(),
          ],
        ),
      ),
    );
  }

  /// When a marker is selected / tapped
  void _onMarkerTapped(Establishment establishment) {
    _showEstablishmentPopup(establishment);
  }

  /// Show a dialog containing information about the marker
  void _showEstablishmentPopup(Establishment establishment) {
    void closePopup() {
      Navigator.of(context).pop();
    }

    Navigator.of(context).push(
      TransparentRoute(
        builder: (BuildContext context) => PopupWidget(
          child: EstablishmentInfoPopup(
            establishment: establishment,
            onCloseTapped: () {
              closePopup();
            },
          ),
          onCloseTapped: () {
            closePopup();
          },
        ),
      ),
    );
  }

  /// Moves the map to a certain coordinate
  void _moveMapToLatLng(LatLng position, {bool instantMove = false}) async {
    // Create gmap camera position
    CameraPosition cameraPosition = CameraPosition(
      target: position,
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

  /// The buttons at the bottom of the screen
  Widget _getButtons() {
    return Flex(
      direction: Axis.vertical,
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
              dragTab: true,
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
                style: TextFactory.lightButtonStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
            thirdTabOptions: TabbedMenuOptions(
              truncated: TextFactory.getCuisineIcon(CuisineType.coffee, width: 24, height: 24),
              expanded: Text(
                t('Cafés'),
                style: TextFactory.lightButtonStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
            fourthTabOptions: TabbedMenuOptions(
              truncated: TextFactory.getCuisineIcon(CuisineType.beer, width: 24, height: 24),
              expanded: Text(
                t('Bars'),
                style: TextFactory.lightButtonStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<Set<Marker>> _getMarkers(List<Establishment> establishments) async {
    Set<Marker> markers = Set();

    establishments.forEach((establishment) async {
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), establishment.defaultCuisineTypeDescription.iconPath);
      markers.add(
        Marker(
          icon: icon,
          markerId: MarkerId(establishment.id),
          position: LatLng(establishment.latitude, establishment.longitude),
          onTap: () {
            _onMarkerTapped(establishment);
          },
        ),
      );
    });

    return markers;
  }

  Widget _getMap() {
    return BlocBuilder<MapBloc, MapBlocState>(
      builder: (context, state) {
        if (state is MapLoadedState) {
          print("Updating map");

          _moveMapToLatLng(LatLng(state.userLatitude, state.userLongitude));

          return FutureBuilder<Set<Marker>>(
              future: _getMarkers(state.establishments),
              builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
                return GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(state.userLatitude, state.userLongitude),
                    zoom: 12,
                  ),
                  mapToolbarEnabled: false,
                  padding: EdgeInsets.only(bottom: 130, left: 5),
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  },
                  onCameraIdle: () async {
                    // TODO Refresh markers when map stops moving
                  },
                  markers: snapshot.data,
                );
              });
        } else if (state is MapErrorState) {
          return Container(color: Colors.red);
        }

        return Container(color: Colors.pink);
      },
    );
  }
}
