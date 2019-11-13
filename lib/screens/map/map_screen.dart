import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/custom_app_bar.dart';
import 'package:user_location/user_location.dart';

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
  MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
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
              BlocBuilder<UserLocationBloc, LatLng>(builder: (context, LatLng state) {
                String text = "Waiting...";

                if (state != null) {
                  text = 'Lat: ' + state.latitude.toString() + ' / Lon: ' + state.longitude.toString();

                  if (mapController.ready) {
                    // TODO move to statefulwidget
                    mapController.move(state, 13.0);
                  }
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

  FlutterMap _getMap() {
    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
        center: new LatLng(51.5, -0.09),
        zoom: 13.0,
        plugins: [],
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1Ijoic2FnZ3JlIiwiYSI6ImNrMnczMDgzaTBhaTkzanBncjJoa3hyczgifQ.e9Voq68it4TpghijFbmb0w',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 80.0,
              height: 80.0,
              point: new LatLng(51.5, -0.09),
              builder: (ctx) => new Container(
                child: new FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
