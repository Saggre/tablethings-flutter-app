import 'package:flutter/cupertino.dart';

/// Designed to be added on a stack
class DragTab extends StatelessWidget {
  final double width;

  DragTab({@required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 7,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width,
          height: 3,
          decoration: BoxDecoration(
            color: Color.fromRGBO(128, 128, 128, 0.2),
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
      ),
    );
  }
}
