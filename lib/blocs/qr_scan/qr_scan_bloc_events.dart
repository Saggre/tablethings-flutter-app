abstract class QRScanBlocEvent {}

/// Event to start scanning for QR-codes in camera input
class StartScanning extends QRScanBlocEvent {}

/// Event to stop scanning
class StopScanning extends QRScanBlocEvent {}
