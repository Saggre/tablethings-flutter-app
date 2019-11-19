import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/main_app_bar.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/secondary_app_bar.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Arguments sent to this screen
class EstablishmentScreenArguments {
  final String establishmentId;
  final String tableId;

  EstablishmentScreenArguments(this.establishmentId, this.tableId);
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

  Widget _getCoverImage(Establishment establishment, {double height}) {
    return Container(
      height: height,
      color: Colors.grey[500],
      child: CachedNetworkImage(
        imageUrl: establishment.imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  /// Main meat of the screen
  Widget _getEstablishmentInfo(Establishment establishment) {
    return Stack(
      children: <Widget>[
        _getCoverImage(establishment, height: 180),
        Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 120)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: EstablishmentInfo(
                establishment: establishment,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Monkas");
    final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

    // Get establishment from db through bloc
    print("Getting establishment: " + args.establishmentId);
    SingleEstablishmentBlocEvent event = SingleEstablishmentBlocEvent(args.establishmentId);
    BlocProvider.of<SingleEstablishmentBloc>(context).add(event);

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
  }
}
