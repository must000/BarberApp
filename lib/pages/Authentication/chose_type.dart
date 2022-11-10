import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Authentication/registerbarber.dart';
import 'package:barber/pages/Authentication/registerhairdresser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChoseType extends StatefulWidget {
  const ChoseType({Key? key}) : super(key: key);

  @override
  State<ChoseType> createState() => _ChoseTypeState();
}

class _ChoseTypeState extends State<ChoseType> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
      ),
      backgroundColor: Contants.myBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "เลือกประเภทการสมัคร",
            style: Contants().h2white(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 150,
                width: size * 0.4,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Contants.colorWhite,
                    )),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterHairdresser(),
                          ));
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.asset(
                              "images/hairdresser.png",
                            ),
                            width: size * 0.20,
                          ),
                          Center(
                              child: Text(
                            "ช่างตัดผม\nช่างเสริมสวย ",
                            style: Contants().h4OxfordBlue(),
                          )),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 150,
                width: size * 0.4,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Contants.colorWhite,
                    )),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const RegisterBarber(),
                      //     ));
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterBarber(),
                          ),
                          (route) => false);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Image.asset(
                              "images/barber2.png",
                            ),
                            width: size * 0.20,
                          ),
                          Center(
                              child: Text("ร้านทำผม\nผู้จัดการร้าน ",
                                  style: Contants().h4OxfordBlue())),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
