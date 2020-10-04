import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant _restaurant;
  final Menu _menu;

  RestaurantScreen(this._restaurant, this._menu);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRScanBloc, QRScanBlocState>(
      builder: (context, state) {
        return Column(
          children: [
            Image.network(
              _restaurant.thumbnail,
            ),
            Text(_restaurant.name),
            Text(_restaurant.description),
            Expanded(
              child: ListView(children: () {
                var list = List<Widget>();

                _menu.sections.forEach((section) {
                  list.add(Container(
                    height: 50,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        //Text(section.name),
                        //Text(section.description),
                      ],
                    ),
                  ));

                  section.items.forEach((item) {
                    list.add(Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.name),
                          Flexible(child: Text(item.description)),
                          Text(item.price.toString()),
                        ],
                      ),
                    ));
                  });
                });

                return list;
              }()),
            )
          ],
        );
      },
    );
  }
}
