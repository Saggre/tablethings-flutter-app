import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/raised_gradient_button.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/theme/theme.dart';

class EstablishmentIconPopup extends StatelessWidget {
  final Establishment establishment;

  const EstablishmentIconPopup({
    Key key,
    @required this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            children: <Widget>[
              EstablishmentImage(imageUrl: establishment.imageUrl, height: 180),
              EstablishmentInfo(
                establishment: establishment,
              ),
            ],
          ),
          RaisedGradientButton(
            text: t('Menu'),
            iconData: Icons.restaurant_menu,
            gradient: buttonGradient,
            onPressed: () {
              var package = FetchablePackage<String, Establishment>(establishment.id);
              package.setFetchedData(establishment);
              EstablishmentScreenArguments args = EstablishmentScreenArguments(
                establishmentPackage: package,
                tableId: "0",
              );

              // Push establishment screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EstablishmentScreen(),
                  settings: RouteSettings(arguments: args),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
