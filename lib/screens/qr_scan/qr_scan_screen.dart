import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'components/lens_cover.dart';

class QRScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<QRScanBloc, QRScanBlocState>(
      builder: (context, state) {
        if (state is ScanningState) {
          return Stack(children: <Widget>[
            CameraPreview(state.cameraController),
            LensCover(),
          ]);
        }

        return Text('Yeet');
      },
    ));
  }
}
