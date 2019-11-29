import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/screens/main_screen.dart';
import 'package:tablething/theme/colors.dart';
import 'blocs/bloc.dart';
import 'localization/translate.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>(builder: (BuildContext context) => MapBloc()),
          BlocProvider<OrderBloc>(builder: (BuildContext context) => OrderBloc()),
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
            primarySwatch: mainThemeMaterialColor,
          ),
          home: MainScreen(),
          routes: {
            EstablishmentScreen.routeName: (context) => EstablishmentScreen(),
          },
        ));
  }
}
