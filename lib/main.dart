import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/screens/main_screen.dart';
import 'package:tablething/theme/colors.dart';
import 'blocs/bloc.dart';
import 'localization/translate.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(builder: (BuildContext context) => AuthBloc()),
          BlocProvider<MapBloc>(builder: (BuildContext context) => MapBloc()),
          BlocProvider<OrderBloc>(builder: (BuildContext context) => OrderBloc()),
        ],
        child: Provider<PersistentData>(
          create: (context) => PersistentData(),
          child: MaterialApp(
            title: t('Tablething'),
            theme: ThemeData(
              // TODO use theme
              primarySwatch: mainThemeMaterialColor,
            ),
            home: MainScreen(),
            routes: {
              EstablishmentScreen.routeName: (context) => EstablishmentScreen(),
            },
          ),
        ));
  }
}
