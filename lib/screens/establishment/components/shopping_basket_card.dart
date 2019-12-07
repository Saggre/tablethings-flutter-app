import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tablething/blocs/order/order_bloc.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/persistent_data.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/services/tablething/order/order.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'menu_view/menu_view_item.dart';

class ShoppingBasketCard extends StatelessWidget {
  final Establishment establishment;
  final Order<MenuItem> order;

  const ShoppingBasketCard({Key key, this.establishment, this.order}) : super(key: key);

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
                        t('Your order'),
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
          ];

          order.items.forEach((orderItem) {
            builder.add(
              Container(
                color: offWhiteColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: offWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: MenuViewItem(
                      menuItem: orderItem.product,
                      establishment: establishment,
                      onPress: (MenuItem menuItem) {
                        BlocProvider.of<OrderBloc>(context).add(
                          RemoveOrderItemEvent(orderItem),
                        );
                      },
                      buttonStyle: MenuViewItemButtonStyle.remove,
                      wholeAreaIsClickable: false,
                      descriptionPadding: 15.0,
                      imageRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
            );

            builder.add(Container(
              color: offWhiteColor,
              padding: EdgeInsets.only(bottom: 15.0),
            ));
          });

          builder.add(
            GestureDetector(
              onTap: () {
                BlocProvider.of<OrderBloc>(context).add(
                  RequestMenuEvent(),
                );
              },
              child: Container(
                color: offWhiteColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: offWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
                  child: Center(
                    child: Text(
                      t('+ Add more items'),
                      style: TextFactory.h2Style.copyWith(color: Colors.grey[500]),
                    ),
                  ),
                ),
              ),
            ),
          );

          builder.add(Container(
            height: 128.0,
            color: offWhiteColor,
          ));

          return builder;
        }());
  }
}
