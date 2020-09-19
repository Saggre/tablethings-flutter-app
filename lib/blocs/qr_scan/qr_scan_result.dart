import 'package:tablething/models/tablethings/restaurant/barcode.dart';

/// QR-code scan base result
class QRScanResult {}

/// Result when there is no QR-code in an image
class QRScanEmptyResult extends QRScanResult {}

/// Result when there is a valid QR-code in an image
class QRScanDataResult extends QRScanResult {
  final Barcode barcode;

  QRScanDataResult(this.barcode);
}

/// Result when an error occurred during the scan
class QRScanErrorResult extends QRScanResult {
  final String errorText;

  QRScanErrorResult(this.errorText);
}
