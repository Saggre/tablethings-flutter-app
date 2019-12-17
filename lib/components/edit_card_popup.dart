import 'package:flutter/material.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

import 'corner_bar.dart';

class EditCardPopup extends StatefulWidget {
  final Function onCloseTapped;

  const EditCardPopup({Key key, this.onCloseTapped}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditCardPopupState();
  }
}

class EditCardPopupState extends State<EditCardPopup> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(48.0),
      child: Container(
        width: double.infinity,
        color: offWhiteColor,
        child: Column(
          children: <Widget>[
            Row(
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
                      onPressed: () => widget.onCloseTapped(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ),
                  child: Center(
                    child: TextFactory.h2(t('Payment method')),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
          ],
        ),
      ),
    );
  }
}
