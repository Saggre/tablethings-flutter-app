import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

mixin MenuViewItemText on Widget {
  Widget getText(MenuItem menuItem, Establishment establishment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          establishment.formatCurrency(menuItem.price),
          style: TextFactory.h4Style.copyWith(color: darkThemeColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFactory.h3(menuItem.name),
            Padding(padding: EdgeInsets.only(right: 10.0)),
          ],
        ),
        TextFactory.p(menuItem.description),
      ],
    );
  }
}
