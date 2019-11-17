import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/raised_gradient_button.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/services/establishment.dart';
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
          EstablishmentInfo(
            establishment: establishment,
          ),
          RaisedGradientButton(
            text: t('Menu'),
            iconData: Icons.restaurant_menu,
            gradient: buttonGradient,
            onPressed: () {
              // TODO open menu
            },
          )
        ],
      ),
    );
  }
}
