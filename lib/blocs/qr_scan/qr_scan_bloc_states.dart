import 'package:camera/camera.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';

abstract class QRScanBlocState {}

/// Scanning is paused
class Paused extends QRScanBlocState {}

/// No camera permission
class NoPermission extends Paused {}

/// Base class for camera-active states
abstract class Active extends QRScanBlocState {
  CameraController cameraController;

  Active(this.cameraController);
}

/// Currently scanning for QR-codes state
class Scanning extends Active {
  Scanning(cameraController) : super(cameraController);
}

/// When something was scanned
class Scanned extends Active {
  QRScanResult scanResult;

  Scanned(this.scanResult, cameraController) : super(cameraController);
}
