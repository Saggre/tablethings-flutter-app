import 'package:flutter/material.dart';
import 'package:tablething/services/establishment.dart';

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

  @override
  Widget build(BuildContext context) {
    final EstablishmentScreenArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(key: _scaffoldKey, body: Container());
  }
}
