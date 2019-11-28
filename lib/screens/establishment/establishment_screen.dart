import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'components/menu_view/menu_view.dart';
import 'dart:math';

/// Arguments sent to this screen
class EstablishmentScreenArguments {
  final FetchablePackage<String, Establishment> establishmentPackage;
  final String tableId;

  EstablishmentScreenArguments({this.establishmentPackage, this.tableId});
}

/// A route for a single establishment showing its info, menu, etc
class EstablishmentScreen extends StatefulWidget {
  static const routeName = '/establishmentScreen';

  EstablishmentScreen({Key key}) : super(key: key);

  @override
  EstablishmentScreenState createState() {
    return EstablishmentScreenState();
  }
}

class EstablishmentScreenState extends State<EstablishmentScreen> {
  double _parallax = 0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // Delayed to after context is initialized
    () async {
      await Future.delayed(Duration.zero);
      final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

      // Get establishment
      print("Getting establishment: " + args.establishmentPackage.getFetchId());
      SingleEstablishmentBlocEvent event = SingleEstablishmentBlocEvent(args.establishmentPackage);
      BlocProvider.of<EstablishmentBloc>(context).add(event);
    }();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: mainThemeColor,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BlocBuilder<EstablishmentBloc, EstablishmentBlocState>(
              builder: (context, state) {
                if (state is SingleEstablishmentBlocState) {
                  if (state.establishment != null) {
                    print("Got establishment");

                    return _getEstablishmentInfo(state.establishment);
                  }
                }
                return CircularProgressIndicator(value: null);
              },
            ),
            MainAppBar(),
          ],
        ),
      ),
    );
  }

  /// Main meat of the screen
  Widget _getEstablishmentInfo(Establishment establishment) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 24,
          ),
          width: double.infinity,
          color: darkThemeColor,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32.0),
              topLeft: Radius.circular(32.0),
            ),
            child: Stack(
              children: <Widget>[
                EstablishmentImage(imageUrl: establishment.imageUrl, height: 160.0),
              ],
            ),
          ),
        ),
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 152.0,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32.0),
                    topLeft: Radius.circular(32.0),
                  ),
                  color: offWhiteColor,
                ),
                child: Column(
                  children: <Widget>[
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        EstablishmentInfo(
                          establishment: establishment,
                        ),
                      ],
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextFactory.h2(t('Menu')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MenuView(
              menu: establishment.menu,
            ),
          ],
        ),
      ],
    );
  }

  Widget _getSearchBar() {
    // TODO onchanged and make its own widget
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0), boxShadow: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0.0, 1.0),
          blurRadius: 5,
        ),
      ]),
      child: Row(
        children: <Widget>[
          Flexible(
              child: TextField(
                  decoration: InputDecoration(
            hintText: t('Search menu'),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ))),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

/*
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            SecondaryAppBar(),
            BlocBuilder<SingleEstablishmentBloc, SingleEstablishmentBlocState>(
              builder: (context, state) {
                if (state.establishment != null) {
                  print("Got establishment");

                  return _getEstablishmentInfo(state.establishment);
                }

                return CircularProgressIndicator(value: null);
              },
            ),
          ],
        ),
      ),
    );
     */
}
