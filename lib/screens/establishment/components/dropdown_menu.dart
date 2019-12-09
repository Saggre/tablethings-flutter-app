import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tablething/theme/theme.dart';
import 'package:tablething/util/text_factory.dart';

class DropdownMenuController<T> {
  T currentValue;
  Function onValueChanged;
}

class DropdownMenu<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final DropdownMenuController<T> controller;
  final Function stringGetter;
  Function _onValueChanged;
  T _currentValue;

  DropdownMenu({@required this.title, @required this.options, @required this.stringGetter, this.controller}) {
    _onValueChanged = (newValue) {
      controller?.currentValue = newValue;
      if (controller?.onValueChanged != null) {
        controller?.onValueChanged(newValue);
      }
    };

    _currentValue = options.first;
    _onValueChanged(_currentValue);
  }

  @override
  State<StatefulWidget> createState() {
    // TODO check options length

    return DropdownMenuState<T>();
  }
}

class DropdownMenuState<T> extends State<DropdownMenu> {
  @override
  void initState() {
    super.initState();
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
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: widget._currentValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 0,
                  underline: Container(),
                  onChanged: (newValue) {
                    setState(() {
                      widget._currentValue = newValue;
                      widget._onValueChanged(newValue);
                    });
                  },
                  style: TextFactory.h4Style,
                  items: widget.options.map((value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Container(
                        child: Text(widget.stringGetter(value)),
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
