import 'package:barber/Constant/contants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRdoe extends StatefulWidget {
  const ScanQRdoe({Key? key}) : super(key: key);

  @override
  State<ScanQRdoe> createState() => _ScanQRdoeState();
}

class _ScanQRdoeState extends State<ScanQRdoe> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        Text(
                          'รหัสช่างทำผมคือ ${result!.code}',
                          style: Contants().h3OxfordBlue(),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, result!.code);
                            },
                            child: Text("ยืนยัน",style: Contants().h3OxfordBlue(),))
                      ],
                    )
                  : Text(
                      'แสกน QRcode',
                      style: Contants().h3OxfordBlue(),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        // idCodeController.text = result!.code!;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
