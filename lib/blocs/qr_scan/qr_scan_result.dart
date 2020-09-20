import 'package:firebase_ml_vision/firebase_ml_vision.dart' show BarcodeValueType;
import 'package:tablethings/models/tablethings/restaurant/barcode.dart';

/// QR-code scan base result
/// These are NOT bloc states, but results from the QR-scanning process
abstract class QRScanResult {}

/// Result when there is no QR-code in an image
class EmptyResult extends QRScanResult {}

/// Base class when there is a valid QR-code in an image
abstract class DataResult extends QRScanResult {}

/// Result when a Tablethings QR-code was scanned
class TablethingsQRResult extends DataResult {
  final Barcode barcode;

  TablethingsQRResult(this.barcode);
}

/// Result when a non-Tablethings QR-code url was scanned
class OtherUrlQRResult extends DataResult {
  final String url;

  OtherUrlQRResult(this.url);
}

/// Result when a QR-code was scanned, but it has unknown data
class UnknownQRResult extends DataResult {
  BarcodeValueType barcodeType;

  UnknownQRResult(this.barcodeType);
}

/// Result when an error occurred during the scan
class ErrorResult extends QRScanResult {
  final String errorMessage;

  ErrorResult(this.errorMessage);
}
