import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/order/order.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';

class CheckoutCard extends StatelessWidget {
  final Establishment establishment;
  final Order order;

  const CheckoutCard({Key key, this.establishment, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        key: ValueKey('ShoppingBasketView'),
        children: () {
          List<Widget> builder = [
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      EstablishmentInfo(
                        establishment: establishment,
                        showDescription: false,
                        showRating: false,
                      ),
                    ],
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        t('Checkout'),
                        style: TextFactory.h2Style,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        t('Order total'),
                        style: TextFactory.h4Style,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // TODO Subtotal
                      Text(
                        establishment.formatCurrency(order.subtotal),
                        style: TextFactory.h3Style.copyWith(color: darkThemeColorGradient),
                      ),
                      Text(
                        Provider.of<PersistentData>(context).selectedTableId, // TODO takeaway
                        style: TextFactory.h3Style.copyWith(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.63, // Credit card dimensions
              color: offWhiteColor,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFEFEFE),
                    borderRadius: BorderRadius.circular(32.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                t('Debit / Credit card'),
                                style: TextFactory.h4Style,
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Container(
                          child: Text(t('+ Add new'), style: TextFactory.h2Style.copyWith(color: Colors.grey[500])),
                        ),
                      ),
                    ],
                  )),
            ),
          ];

          builder.add(Container(
            height: 128.0,
          ));

          return builder;
        }());
  }
}
