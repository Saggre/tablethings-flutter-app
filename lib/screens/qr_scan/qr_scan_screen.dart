import 'dart:async';
import 'dart:ui';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:tablething/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:tablething/components/custom_app_bar.dart';

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

  Future<String> _barcodeString;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(),
      body: Stack(children: <Widget>[]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          setState(() {
            _barcodeString = new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan();

            _barcodeString.then((value) {
              print("Barcode: " + value);
            });
          });
        },
        tooltip: 'Reader the QRCode',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
