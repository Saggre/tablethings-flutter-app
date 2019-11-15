import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:tablething/components/custom_app_bar.dart';
import 'package:tablething/main.dart';

class QRScanScreen extends StatefulWidget {
  final bool isFullScreenDialog;

  QRScanScreen({Key key, this.isFullScreenDialog = false}) : super(key: key);

  @override
  QRScanScreenState createState() {
    return QRScanScreenState();
  }
}

class QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  /// Start the camera
  void _initCamera() async {
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _cameraController.startImageStream((CameraImage availableImage) {
        //_cameraController.stopImageStream();
        _scanQRCode(availableImage);
      });

      setState(() {});
    });
  }

  /// Scan a camera image containing a QR-code (hopefully)
  void _scanQRCode(CameraImage cameraImage) async {
    //print('Scanning QR');

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

    for (Barcode barcode in barcodes) {
      final Rect boundingBox = barcode.boundingBox;
      final List<Offset> cornerPoints = barcode.cornerPoints;

      final String rawValue = barcode.rawValue;

      final BarcodeValueType valueType = barcode.valueType;

      // See API reference for complete list of supported types
      switch (valueType) {
        case BarcodeValueType.wifi:
          final String ssid = barcode.wifi.ssid;
          final String password = barcode.wifi.password;
          final BarcodeWiFiEncryptionType type = barcode.wifi.encryptionType;
          break;
        case BarcodeValueType.url:
          final String title = barcode.url.title;
          final String url = barcode.url.url;
          print('Scanned URL qr-code');
          break;
        default:
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Get widget containing camera's view
  Widget _getCameraView() {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: _cameraController.value.aspectRatio,
      child: CameraPreview(_cameraController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(),
      body: Stack(children: <Widget>[
        _getCameraView(),
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Reader the QRCode',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
