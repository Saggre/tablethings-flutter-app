import 'package:flutter/widgets.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

class MenuViewItemText extends StatelessWidget {
  final MenuItem menuItem;
  final Establishment establishment;
  final String titlePrefix;

  MenuViewItemText({
    this.menuItem,
    this.establishment,
    this.titlePrefix,
  });

  @override
  Widget build(BuildContext context) {
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
            TextFactory.h3((titlePrefix ?? '') + menuItem.name),
            Padding(padding: EdgeInsets.only(right: 10.0)),
          ],
        ),
        TextFactory.p(menuItem.description),
      ],
    );
  }
}
