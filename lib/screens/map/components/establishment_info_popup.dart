import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/buttons/single_button.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

class EstablishmentInfoPopup extends StatelessWidget {
  final Establishment establishment;

  const EstablishmentInfoPopup({
    Key key,
    @required this.establishment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        color: Colors.black38,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: Container(
            decoration: BoxDecoration(
              color: offWhiteColor,
            ),
            child: Column(
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
                DualButton(
                  properties: DualButtonProperties(),
                  leftButtonProperties: SingleButtonProperties(
                    text: t('Button2'),
                    textStyle: TextFactory.lightButtonStyle,
                    colors: [
                      Colors.white,
                    ],
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  /*rightButtonProperties: SingleButtonProperties(
                    text: t('Menu'),
                    textStyle: TextFactory.buttonStyle,
                    colors: [
                      darkThemeColorGradient,
                      darkThemeColor,
                    ],
                    iconData: Icons.restaurant_menu,
                    borderRadius: BorderRadius.circular(32.0),
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
                  ),*/
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
