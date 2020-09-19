import 'package:camera/camera.dart';
import 'package:tablething/models/tablethings/restaurant/barcode.dart';

class QRScanBlocState {}

/// Scanning is paused
class PausedState extends QRScanBlocState {}

/// Currently scanning for QR-codes state
class ScanningState extends QRScanBlocState {
  CameraController cameraController;

  ScanningState(this.cameraController);
}

/// When a QR-code was successfully scanned
class ScannedQR extends QRScanBlocState {
  Barcode barcode;

  ScannedQR(this.barcode);
}
