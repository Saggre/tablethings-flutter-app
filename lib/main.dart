import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/screens/main_screen.dart';
import 'package:tablething/theme/colors.dart';
import "package:i18n_extension/i18n_widget.dart";

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<QRScanBloc>(
            create: (BuildContext context) => QRScanBloc(),
          ),
        ],
        child: Provider<PersistentData>(
          create: (context) => PersistentData(),
          child: MaterialApp(
            title: 'Tablethings',
            theme: ThemeData(
              // TODO use theme
              primarySwatch: mainThemeMaterialColor,
            ),
            home: I18n(child: MainScreen()),
            routes: {},
          ),
        ));
  }
}
