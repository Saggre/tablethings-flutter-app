import 'package:flutter/material.dart';
import 'qr_scan/qr_scan_screen.dart';

/// Main screen that acts as a parent to other screens (and animates their transitions?)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QRScanScreen();
  }
}
