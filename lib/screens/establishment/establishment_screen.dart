import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/colored_safe_area.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/screens/establishment/components/establishment_app_bar.dart';
import 'package:tablething/theme/colors.dart';
import 'components/menu_view/menu_view.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  /// Main meat of the screen
  Widget _getEstablishmentInfo(Establishment establishment) {
    return CustomScrollView(
      slivers: <Widget>[
        EstablishmentAppBar(
          establishment: establishment,
        ),
        SliverToBoxAdapter(
          child: EstablishmentInfo(
            child: Column(
              children: <Widget>[
                _getSearchBar(),
              ],
            ),
            establishment: establishment,
          ),
        ),
        MenuView(
          menu: establishment.menu,
        ),
      ],
    );

    return Stack(
      children: <Widget>[
        EstablishmentImage(imageUrl: establishment.imageUrl, height: 180),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 120)),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  EstablishmentInfo(
                    child: Column(
                      children: <Widget>[
                        _getSearchBar(),
                      ],
                    ),
                    establishment: establishment,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5.0), boxShadow: [
                      BoxShadow(
                        color: Color(0x66000000),
                        offset: Offset(0.0, 1.0),
                        blurRadius: 5,
                      ),
                    ]),
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

    // Get establishment
    print("Getting establishment: " + args.establishmentPackage.getFetchId());
    SingleEstablishmentBlocEvent event = SingleEstablishmentBlocEvent(args.establishmentPackage);
    BlocProvider.of<SingleEstablishmentBloc>(context).add(event);

    return ColoredSafeArea(
      color: appColors[0],
      child: Scaffold(
        key: _scaffoldKey,
        body: BlocBuilder<SingleEstablishmentBloc, SingleEstablishmentBlocState>(
          builder: (context, state) {
            if (state.establishment != null) {
              print("Got establishment");

              return _getEstablishmentInfo(state.establishment);
            }

            return CircularProgressIndicator(value: null);
          },
        ),
      ),
    );

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
}
