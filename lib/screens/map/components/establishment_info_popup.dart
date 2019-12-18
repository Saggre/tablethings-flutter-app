import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/components/buttons/dual_button.dart';
import 'package:tablething/components/corner_bar.dart';
import 'package:tablething/components/establishment_image.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/components/buttons/single_button.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

class EstablishmentInfoPopup extends StatelessWidget {
  final Establishment establishment;
  final Function onCloseTapped;

  const EstablishmentInfoPopup({
    Key key,
    @required this.establishment,
    @required this.onCloseTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(32.0),
      child: Container(
        color: offWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                EstablishmentImage(imageUrl: establishment.imageUrl, height: 152),
                Container(
                  height: 152,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CornerBar(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        color: darkThemeColor,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              onCloseTapped();
                            },
                          ),
                        ],
                      ),
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
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  EstablishmentInfo(
                    establishment: establishment,
                  ),
                ],
              ),
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
                  // Close the popup
                  onCloseTapped();

                  BlocProvider.of<OrderBloc>(context).add(
                    GetEstablishmentEvent(
                      establishment.id,
                      'No table',
                    ),
                  );

                  // Push establishment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EstablishmentScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
