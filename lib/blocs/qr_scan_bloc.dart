import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:tablething/localization/translate.dart';

class QRScanBlocEvent {
  CameraImage cameraImage;

  QRScanBlocEvent(this.cameraImage);
}

class QRScanBlocState {}

/// When no qr code is scanned
class EmptyQRScanBlocState extends QRScanBlocState {}

/// When an error arises
class ErrorQRScanBlocState extends QRScanBlocState {
  String errorText;

  ErrorQRScanBlocState(this.errorText);
}

/// When a qr code is scanned
class DataQRScanBlocState extends QRScanBlocState {
  String establishmentId;
  String tableId;

  DataQRScanBlocState(this.establishmentId, this.tableId);
}

/// Creates events from user movement in real world
/// Bloc<Event, State>
class QRScanBloc extends Bloc<QRScanBlocEvent, QRScanBlocState> {
  UserLocationBloc() {
    // TODO debug
  }

  @override
  // Init with empty list
  QRScanBlocState get initialState => EmptyQRScanBlocState();

  @override
  Stream<QRScanBlocState> mapEventToState(QRScanBlocEvent event) async* {
    print('Scanning QR');

    if (event.cameraImage == null) {
      yield EmptyQRScanBlocState();
    }

    try {
      // Create mlkit image from camera image and process it
      // TODO check planeData and rawFormat for iOS
      final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
          size: Size(event.cameraImage.width.toDouble(), event.cameraImage.height.toDouble()),
          planeData: event.cameraImage.planes
              .map((currentPlane) =>
                  FirebaseVisionImagePlaneMetadata(bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
              .toList(),
          rawFormat: event.cameraImage.format.raw,
          rotation: ImageRotation.rotation90);
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(event.cameraImage.planes[0].bytes, metadata);
      final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

      // Parse qr code url into needed data
      QRScanBlocState _parseUrl(String url) {
        // URL should of the form:
        // establishment-id is RFC4122 v4
        // https://tablething.io/place=establishment-id/table=table-id
        // Ex: https://tablething.io/place=110ec58a-a0f2-4ac4-8393-c866d813b8d1/table=10

        String cleanUrl = url;

        // Replace wrong-way slashes
        cleanUrl = cleanUrl.replaceAll(RegExp(r'\\'), '/'); // \?extra-data\ => /?extra-data/

        // Replace trailing slash
        cleanUrl = cleanUrl.replaceAll(RegExp(r'\/$'), ''); // extra-data/ => ?extra-data

        RegExp establishmentIdRegExp = RegExp(r'place=([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})');
        RegExp tableIdRegExp = RegExp(r'table=(\d+)');

        String establishmentId = establishmentIdRegExp.firstMatch(cleanUrl).group(0);
        String tableId = tableIdRegExp.firstMatch(cleanUrl).group(0);

        // If something is wrong with the parsed values
        if (establishmentId == null || tableId == null || establishmentId.length == 0 || tableId.length == 0) {
          return ErrorQRScanBlocState(t('Invalid QR-code'));
        }

        return DataQRScanBlocState(establishmentId, tableId);
      }

      // For loop really returns the first value
      // TODO what if there are 2 QR-codes next to each other?
      for (Barcode barcode in barcodes) {
        final BarcodeValueType valueType = barcode.valueType;

        // Return a state
        switch (valueType) {
          case BarcodeValueType.url:
            final String title = barcode.url.title;
            final String url = barcode.url.url;
            yield _parseUrl(url);
            break;
          default:
            yield EmptyQRScanBlocState();
        }
      }
    } catch (err) {
      yield ErrorQRScanBlocState(t('An unknown error occurred'));
    }
  }
}
