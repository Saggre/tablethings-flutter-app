import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment_barcode.dart';
import 'package:flutter/material.dart';
import 'package:tablething/screens/establishment/establishment_screen.dart';
import 'components/lens_cover.dart';

class QRScanResult {}

class QRScanEmptyResult extends QRScanResult {}

class QRScanDataResult extends QRScanResult {
  final EstablishmentBarcode barcodeData;

  QRScanDataResult(this.barcodeData);
}

class QRScanErrorResult extends QRScanResult {
  final String errorText;

  QRScanErrorResult(this.errorText);
}

class QRScanScreen extends StatefulWidget {
  QRScanScreen({Key key}) : super(key: key);

  @override
  QRScanScreenState createState() {
    return QRScanScreenState();
  }
}

/// Doesn't implement bloc pattern
class QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController _cameraController;
  List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  /// Start the camera
  void _initCamera() async {
    _cameras = await availableCameras();

    _cameraController = CameraController(_cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      int scanTimeout = 500;
      Stopwatch stopwatch = Stopwatch();
      stopwatch.start();

      _cameraController.startImageStream((CameraImage availableImage) {
        //_cameraController.stopImageStream();
        if (stopwatch.elapsedMilliseconds > scanTimeout) {
          stopwatch.reset();

          // Send event
          _scanBarcode(availableImage, (result) {
            if (result is QRScanEmptyResult) {
              // No code scanned
            } else if (result is QRScanDataResult) {
              print("Scanned establishment: " + result.barcodeData.establishmentId + ", table: " + result.barcodeData.tableId);
              _pushEstablishmentScreen(result.barcodeData.establishmentId, result.barcodeData.tableId);
            } else if (result is QRScanErrorResult) {
              // Error
            }
          });
        }
      });

      // Rebuild with camera
      setState(() {});
    });
  }

  /// Navigate to establishment screen and send data to it
  void _pushEstablishmentScreen(String establishmentId, String tableId) {

    BlocProvider.of<OrderBloc>(context).add(
      GetEstablishmentEvent(
        establishmentId,
        tableId,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EstablishmentScreen(),
      ),
    );
  }

  /// Scan barcode from image and call callback with result
  /// No bloc pattern because no widget is updated from barcode data
  void _scanBarcode(CameraImage cameraImage, Function(QRScanResult) onScan) async {
    print('Scanning QR');

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
              .map((currentPlane) => FirebaseVisionImagePlaneMetadata(bytesPerRow: currentPlane.bytesPerRow, height: currentPlane.height, width: currentPlane.width))
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
          return QRScanErrorResult(t('Invalid QR-code'));
        }

        return QRScanDataResult(EstablishmentBarcode(establishmentId, tableId));
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
      onScan(QRScanErrorResult(t('An unknown error occurred')));
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Get widget containing camera's view
  Widget _getCameraView() {
    // cameraController is created in an async function so it may be null here
    if (_cameraController != null && _cameraController.value.isInitialized) {
      return CameraPreview(_cameraController);
    }

    // TODO add some sort of camera loader
    return Container(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        _getCameraView(),
        LensCover(),
      ]),
    );
  }
}
