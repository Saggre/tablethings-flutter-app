import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PopupWidget extends StatelessWidget {
  final Function onCloseTapped;
  final Widget child;

  const PopupWidget({
    Key key,
    @required this.onCloseTapped,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
          alignment: Alignment.center,
          color: Colors.black38,
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onCloseTapped();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: child,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onCloseTapped();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
