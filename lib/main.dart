import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/screens/main_screen.dart';
import 'package:tablething/services/user.dart';
import 'package:tablething/theme/colors.dart';

import 'blocs/bloc.dart';
import 'localization/translate.dart';

List<CameraDescription> cameras;

void main() async {
  // TODO move to different method
  // Get phone cameras
  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserLocationBloc>(builder: (BuildContext context) => UserLocationBloc()),
          BlocProvider<GeoEstablishmentBloc>(builder: (BuildContext context) => GeoEstablishmentBloc()),
          BlocProvider<SingleEstablishmentBloc>(builder: (BuildContext context) => SingleEstablishmentBloc()),
        ],
        child: MaterialApp(
          title: t('Tablething'),
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.teal,
          ),
          home: MainScreen(),
          routes: {
            EstablishmentScreen.routeName: (context) => EstablishmentScreen(),
          },
        ));
  }
}
