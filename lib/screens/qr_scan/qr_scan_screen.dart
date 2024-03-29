import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'components/lens_cover.dart';

class QRScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRScanBloc, QRScanBlocState>(
      builder: (context, state) {
        if (state is Paused) {
          if (state is NoPermission) {
            return Text('No permission');
          } else {
            return Text('Paused');
          }
        } else if (state is Active) {
          return Stack(children: <Widget>[
            CameraPreview(state.cameraController),
            LensCover(),
            Center(
                child: Text(() {
              if (state is Scanned) {
                var result = state.scanResult;
                if (result is OtherUrlQRResult) {
                  return result.url;
                } else if (result is UnknownQRResult) {
                  return result.barcodeType;
                } else if (result is TablethingsQRResult) {
                  return result.barcode.restaurantId;
                }
              }

              return '';
            }(), style: Theme.of(context).textTheme.subtitle1))
          ]);
        }

        return Text('Yeet');
      },
    );
  }
}
