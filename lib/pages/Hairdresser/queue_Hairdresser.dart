import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Hairdresser/queue_setting_hairdresser.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QueueHairdresser extends StatefulWidget {
  String hairdresserID;
  String barberState;
  String idCode;
  QueueHairdresser({
    Key? key,
    required this.hairdresserID,
    required this.barberState,
    required this.idCode,
  }) : super(key: key);

  @override
  State<QueueHairdresser> createState() => _QueueHairdresserState(
      hairdresserID: hairdresserID, barberState: barberState, idCode: idCode);
}

class _QueueHairdresserState extends State<QueueHairdresser> {
  String hairdresserID;
  String barberState;
  String idCode;
  final Uri _url = Uri.parse('https://flutter.dev');
  _QueueHairdresserState(
      {required this.hairdresserID,
      required this.barberState,
      required this.idCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      body: SafeArea(
          child: barberState == "no"
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ยังไม่มีร้านทำผมสำหรับไอดีนี้",
                        style: Contants().h2white(),
                      ),
                      Text(
                        idCode,
                        style: Contants().h3white(),
                      ),
                      TextButton(
                          onPressed: () {
                            _launchUrl();
                          },
                          child: Text(
                            "เข้าสู่หน้าผู้จัดการร้าน",
                            style: TextStyle(color: Contants.colorRed),
                          ))
                    ],
                  ),
                )
              : Center(
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QueueSettingHairdresser(
                                  emailBarber: barberState,
                                  idHairdresser: hairdresserID),
                            ));
                      },
                      icon: Icon(Icons.settings)),
                )),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
