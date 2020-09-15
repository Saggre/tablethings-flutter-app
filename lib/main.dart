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
  final _authBloc;

  MainApp() : _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (BuildContext context) => _authBloc),
          BlocProvider<MapBloc>(create: (BuildContext context) => MapBloc()),
          BlocProvider<OrderBloc>(create: (BuildContext context) => OrderBloc()),
          BlocProvider<PaymentMethodBloc>(create: (BuildContext context) => PaymentMethodBloc(_authBloc)),
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
