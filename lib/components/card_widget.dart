import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'package:tablething/services/stripe/card.dart' as stripe;

class CardWidget extends StatelessWidget {
  final stripe.Card card;
  final EdgeInsets padding;

  CardWidget({@required this.card, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: padding,
        child: Container(
          height: (MediaQuery.of(context).size.width - padding.left - padding.right) * 0.63, // Credit card dimensions
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: darkThemeColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Text(
                      t('Debit / Credit card'),
                      style: TextFactory.h4Style.copyWith(color: Colors.grey[400]),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFd99b2c),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Color(0xFFb78023), width: 1.0),
                          ),
                          width: 54.0,
                          height: 39.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 13.0,
                                width: 52.0,
                                padding: EdgeInsets.only(top: 17.0),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFb78023), width: 1.0)),
                                ),
                              ),
                              Container(
                                height: 13.0,
                                width: 52.0,
                                padding: EdgeInsets.only(top: 17.0),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Color(0xFFb78023), width: 1.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: AutoSizeText(
                      '**** **** **** ' + card.last4,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontFamily: TextFactory.fontFamily,
                        fontSize: 23,
                        letterSpacing: 1.0,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Color(0x66000000),
                            offset: Offset(0.5, 1.0),
                          ),
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Valid thru ',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w300,
                              fontFamily: TextFactory.fontFamily,
                              fontSize: 15,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Color(0x11000000),
                                  offset: Offset(0.5, 1.0),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            card.expMonth.toString() + '/' + card.expYear.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: TextFactory.fontFamily,
                              fontSize: 16,
                              letterSpacing: 1.0,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Color(0x66000000),
                                  offset: Offset(0.5, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
