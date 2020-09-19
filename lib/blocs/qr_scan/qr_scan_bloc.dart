import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_bloc_events.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablething/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablething/models/tablethings/restaurant/barcode.dart' as RestaurantBarcode;

class QRScanBloc extends Bloc<QRScanBlocEvent, QRScanBlocState> {
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  StreamController<QRScanResult> _scanResultStream;
  int _scanTimeout;

  QRScanBloc() : super(PausedState()) {
    _scanTimeout = 500;
    _scanResultStream = StreamController<QRScanResult>();

    // Call start scanning
    this.add(StartScanningEvent());
  }

  @override
  Stream<QRScanBlocState> mapEventToState(QRScanBlocEvent event) async* {
    if (event is StartScanningEvent) {
      _startScanning();
      yield* _scanResultStream.stream.map((result) {
        if (result is QRScanEmptyResult) {
          // TODO No code scanned
        } else if (result is QRScanDataResult) {
          print(sprintf('Successfully scanned a QR-code for: restaurant %s, table %s', [result.barcode.restaurantId, result.barcode.tableId]));
          return ScannedQR(result.barcode);
        } else if (result is QRScanErrorResult) {
          // TODO Error
        }

        return ScanningState(_cameraController);
      });
    }
  }

  /// Start scanning for QR-codes
  void _startScanning() async {
    _cameras = await availableCameras();

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    _cameraController?.dispose();
    _cameraController = CameraController(_cameras.first, ResolutionPreset.high);
    await _cameraController.initialize();

    _cameraController.startImageStream((CameraImage barcodeImage) {
      if (stopwatch.elapsedMilliseconds < _scanTimeout) {
        return;
      }

      stopwatch.reset();

      // Check if there is a QR-code in current image
      _scanBarcode(barcodeImage, (scanResult) {
        _scanResultStream.add(scanResult);
      });
    });
  }

  /// Scan barcode from image and callback with result
  void _scanBarcode(CameraImage cameraImage, Function(QRScanResult) onScan) async {
    log('Scanning a QR-code');

    if (cameraImage == null) {
      onScan(QRScanResult());
      return;
    }

    try {
      // Create mlkit image from camera image and process it
      // TODO check planeData and rawFormat for iOS
      final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          planeData: cameraImage.planes
              .map((currentPlane) =>
                  FirebaseVisionImagePlaneMetadata(bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
              .toList(),
          rawFormat: cameraImage.format.raw,
          rotation: ImageRotation.rotation90);
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(cameraImage.planes[0].bytes, metadata);
      final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

      // Parse qr code url into needed data
      QRScanResult _parseUrl(String url) {
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

        String establishmentId = establishmentIdRegExp.firstMatch(cleanUrl).group(1);
        String tableId = tableIdRegExp.firstMatch(cleanUrl).group(1);

        // If something is wrong with the parsed values
        if (establishmentId == null || tableId == null || establishmentId.length == 0 || tableId.length == 0) {
          return QRScanErrorResult('Invalid QR-code');
        }

        return QRScanDataResult(RestaurantBarcode.Barcode(establishmentId, tableId));
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
            onScan(_parseUrl(url));
            break;
          default:
            onScan(QRScanResult());
        }
      }
    } catch (err) {
      onScan(QRScanErrorResult('An unknown error occurred'));
    }
  }

  dispose() {
    _cameraController?.dispose();
    _scanResultStream?.close();
  }
}
