import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';

class RestaurantScreen extends StatelessWidget {
  final Restaurant _restaurant;

  RestaurantScreen(this._restaurant);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRScanBloc, QRScanBlocState>(
      builder: (context, state) {
        return Text(_restaurant.name);
      },
    );
  }
}
