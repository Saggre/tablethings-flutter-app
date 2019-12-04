import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/order/order_bloc.dart';
import 'package:tablething/blocs/order/order_bloc_events.dart';
import 'package:tablething/components/establishment_info.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/theme/colors.dart';
import 'package:tablething/util/text_factory.dart';
import 'menu_view/menu_view.dart';

class EstablishmentCard extends StatelessWidget {
  final Establishment establishment;
  final Menu menu;

  const EstablishmentCard({Key key, this.establishment, this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('EstablishmentView'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.0),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  EstablishmentInfo(
                    establishment: establishment,
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
                  TextFactory.h2(t('Menu')),
                ],
              ),
            ],
          ),
        ),
        MenuView(
          menu: menu,
          establishment: establishment,
          onAddItem: (MenuItem menuItem) {
            BlocProvider.of<OrderBloc>(context).add(
              CreateOrderItemEvent(menuItem),
            );
          },
        ),
        Container(
          height: 64.0,
          color: offWhiteColor,
        ),
      ],
    );
  }
}
