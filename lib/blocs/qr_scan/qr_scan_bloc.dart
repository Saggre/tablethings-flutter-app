import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_events.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablethings/models/tablethings/restaurant/barcode.dart' as RestaurantBarcode;
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';

class QRScanBloc extends Bloc<QRScanBlocEvent, QRScanBlocState> {
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  StreamController<QRScanResult> _scanResultStream;
  int _scanTimeout;
  Restaurant _latestScannedRestaurant;

  QRScanBloc() : super(Paused()) {
    _scanTimeout = 500;
    _latestScannedRestaurant = null;

    // Call start scanning
    add(StartScanning());

    SystemChannels.lifecycle.setMessageHandler((String event) async {
      print('Changed lifecycle state to: $event');

      if (event == AppLifecycleState.resumed.toString()) {
        add(StartScanning());
      } else if (event == AppLifecycleState.detached.toString()) {
        add(StopScanning());
      } else if (event == AppLifecycleState.inactive.toString()) {
        add(StopScanning());
      } else if (event == AppLifecycleState.paused.toString()) {
        add(StopScanning());
      }

      return '';
    });
  }

  @override
  void add(QRScanBlocEvent event) async {
    if (event is StopScanning) {
      // Stop blocking stream before handling event
      await _scanResultStream?.close();
    }

    super.add(event);
  }

  @override
  Stream<QRScanBlocState> mapEventToState(QRScanBlocEvent event) async* {
    if (event is StartScanning) {
      if (!await _startScanning()) {
        yield NoPermission();
      }

      yield* _scanResultStream.stream.map((result) {
        if (result is EmptyResult) {
          return Scanning(_cameraController);
        }

        if (result is ErrorResult) {
          // TODO send error
          print(sprintf('Error while scanning QR-codes: %s', [result.errorMessage]));
        }

        if (result is TablethingsQRResult) {
          print(sprintf('Scanned a QR-code for: restaurant %s, table %s', [result.barcode.restaurantId, result.barcode.tableId]));
        } else if (result is OtherUrlQRResult) {
          print(sprintf('Scanned a foreign url: %s', [result.url]));
        } else if (result is UnknownQRResult) {
          print(sprintf('Scanned an unknown QR-code of type: %s', [result.barcodeType.toString()]));
        }

        return Scanned(result, _cameraController);
      });
    } else if (event is StopScanning) {
      log('Stopping scanning');
      await _stopScanning();
      yield Paused();
    }
  }

  /// Start scanning for QR-codes
  /// Returns true if scanning could be started, and false if not (like if we have no camera permission for example)
  Future<bool> _startScanning() async {
    if (!await Permission.camera.request().isGranted) {
      return false;
    }

    _scanResultStream = StreamController<QRScanResult>();
    _cameras = await availableCameras();

    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();

    _cameraController = CameraController(_cameras.first, ResolutionPreset.high, enableAudio: false);
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

    return true;
  }

  /// Stops any ongoing scanning
  Future<void> _stopScanning() async {
    log('Stopping scanning');

    try {
      await _cameraController?.stopImageStream();
    } catch (e) {}

    _cameraController?.dispose();
  }

  /// Scan barcode from image and callback with result
  void _scanBarcode(CameraImage cameraImage, Function(QRScanResult) callback) async {
    //log('Looking for QR-codes');

    if (cameraImage == null) {
      callback(ErrorResult('No camera output detected'));
      return;
    }

    try {
      // Create MLKit image from camera image and process it
      final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
          size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
          planeData: cameraImage.planes.map((currentPlane) {
            return FirebaseVisionImagePlaneMetadata(bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width);
          }).toList(),
          rawFormat: cameraImage.format.raw,
          rotation: ImageRotation.rotation90);

      final BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
      final List<Barcode> barcodes = await barcodeDetector.detectInImage(FirebaseVisionImage.fromBytes(cameraImage.planes[0].bytes, metadata));

      // For loop really returns the first value
      // TODO what if there are 2 QR-codes next to each other?
      for (Barcode barcode in barcodes) {
        if (barcode.valueType == BarcodeValueType.url) {
          final String url = barcode.url.url;

          List<String> qrCodeStrings = _parseUrl(url);

          // If something is wrong with the parsed values
          if (qrCodeStrings[0] == null || qrCodeStrings[1] == null || qrCodeStrings[0].isEmpty || qrCodeStrings[1].isEmpty) {
            callback(OtherUrlQRResult(url));
            return;
          }

          callback(TablethingsQRResult(RestaurantBarcode.Barcode(qrCodeStrings[0], qrCodeStrings[1])));
          return;
        } else {
          callback(UnknownQRResult(barcode.valueType));
        }
      }
    } catch (err) {
      callback(ErrorResult(err.toString()));
    }

    callback(EmptyResult());
  }

  /// Parse a Tablethings url into its data components
  /// Url should of the format:
  /// https://tablething.io/place=restaurant-id/table=table-id
  /// Ex: https://tablething.io/place=110ec58a-a0f2-4ac4-8393-c866d813b8d1/table=10
  /// restaurant-id is RFC4122 v4
  List<String> _parseUrl(String url) {
    String cleanUrl = url;

    // Replace wrong-way slashes
    cleanUrl = cleanUrl.replaceAll(RegExp(r'\\'), '/'); // \?extra-data\ => /?extra-data/

    // Remove trailing slash
    cleanUrl = cleanUrl.replaceAll(RegExp(r'\/$'), ''); // extra-data/ => ?extra-data

    RegExp idRegExp = RegExp(r'place=([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})'); // Regex for getting restaurant id
    RegExp tableIdRegExp = RegExp(r'table=(\d+)'); // Regex for getting table id

    String restaurantId = idRegExp.firstMatch(cleanUrl)?.group(1);
    String tableId = tableIdRegExp.firstMatch(cleanUrl)?.group(1);

    return [restaurantId, tableId];
  }

  dispose() {
    _cameraController?.dispose();
    _scanResultStream?.close();
  }
}
