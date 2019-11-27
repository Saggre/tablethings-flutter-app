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
            color: offWhiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        EstablishmentImage(imageUrl: establishment.imageUrl, height: 150),
                        Container(
                          height: 32,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: offWhiteColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: EstablishmentInfo(
                        establishment: establishment,
                      ),
                    ),
                  ],
                ),
                DualButton(
                  properties: DualButtonProperties(
                    separatorDirection: DualButtonSeparatorDirection.leftHand,
                  ),
                  rightButtonProperties: SingleButtonProperties(
                    text: t('Menu'),
                    textStyle: TextFactory.buttonStyle,
                    colors: [
                      darkThemeColorGradient,
                      darkThemeColor,
                    ],
                    enableDragTab: true,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
