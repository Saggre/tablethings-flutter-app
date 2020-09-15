import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/screens/main_screen.dart';
import 'package:tablething/theme/colors.dart';
import 'localization/translate.dart';

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
        providers: [],
        child: Provider<PersistentData>(
          create: (context) => PersistentData(),
          child: MaterialApp(
            title: t('Tablething'),
            theme: ThemeData(
              // TODO use theme
              primarySwatch: mainThemeMaterialColor,
            ),
            home: MainScreen(),
            routes: {},
          ),
        ));
  }
}
