import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

class DropdownMenuController<T> {
  T currentValue;
  Function onValueChanged;
}

class DropdownMenu extends StatefulWidget {
  final String title;
  final List<String> options;
  final DropdownMenuController controller;
  Function onChangeValue;

  DropdownMenu({@required this.title, @required this.options, this.controller}) {
    onChangeValue = (newValue) {
      controller?.currentValue = newValue;
      if (controller?.onValueChanged != null) {
        controller?.onValueChanged(newValue);
      }
    };

    controller?.currentValue = options[0];
  }

  @override
  State<StatefulWidget> createState() {
    // TODO check options length

    return DropdownMenuState();
  }
}

class DropdownMenuState extends State<DropdownMenu> {
  String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.options[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: TextFactory.h4(widget.title),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                ),
              ),
              Expanded(
                flex: 10,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _value,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 0,
                  underline: Container(),
                  onChanged: (String newValue) {
                    widget.onChangeValue(newValue);
                    setState(() {
                      _value = newValue;
                    });
                  },
                  style: TextFactory.h4Style,
                  items: widget.options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
