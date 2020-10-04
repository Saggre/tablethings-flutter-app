import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablethings/models/persistent_data.dart';
import 'package:tablethings/screens/main_screen.dart';
import 'package:tablethings/theme/colors.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_bloc_states.dart';
import 'blocs/navigation/navigation_bloc.dart';
import 'blocs/navigation/navigation_bloc_states.dart';
import 'blocs/qr_scan/qr_scan_bloc_states.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp();

  @override
  Widget build(BuildContext context) {
    // Set orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<QRScanBloc>(
          create: (BuildContext context) => QRScanBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<NavigationBloc>(
          create: (BuildContext context) => NavigationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Tablethings',
        theme: ThemeData(
          // TODO use theme
          primarySwatch: mainThemeMaterialColor,
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.blueGrey),
            subtitle1: TextStyle(color: Colors.blueGrey),
          ),
        ),
        home: I18n(child: MainScreen()),
        routes: {},
      ),
    );
  }
}
