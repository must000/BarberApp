import 'package:flutter/material.dart';

class Contants {
  static String keyLongdomap = "f347b56e94df23bde1dd8d0fc4bfa954";
  static String bundleID =
      "localhost,*,console.firebase.google.com/project/barberapp-d8c95";

  static Color colorOxfordBlue = const Color(0xff14213D);
  static Color colorSpringGreen = const Color(0xff00FF66);
  static Color colorYellow = const Color(0xffFCA311);
  static Color colorBlack = const Color(0xff1C1919);
  static Color colorRed = const Color(0xffFF0000);
  static Color colorGreySilver = const Color(0xffA0A0A0);
    static Color colorWhite = const Color.fromARGB(255, 255, 255, 255);

  static Color myBackgroundColor = const Color(0xff14213D);
  static Color myBackgroundColordark = colorBlack;
  String font = 'Itim';
  TextStyle h1OxfordBlue() => TextStyle(
        fontSize: 30,
        color: colorOxfordBlue,
        fontFamily: font,
      );
  TextStyle h2OxfordBlue() => TextStyle(
        fontSize: 25,
        color: colorOxfordBlue,
        fontFamily: font,
      );
  TextStyle h3OxfordBlue() => TextStyle(
        fontSize: 20,
        color: colorOxfordBlue,
        fontFamily: font,
      );
  TextStyle h4OxfordBlue() => TextStyle(
        fontSize: 15,
        color: colorOxfordBlue,
        fontFamily: font,
      );

  TextStyle h1white() => TextStyle(
        fontSize: 30,
        color: Colors.white,
        fontFamily: font,
      );
  TextStyle h2white() => TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontFamily: font,
      );
  TextStyle h3white() => TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontFamily: font,
      );
  TextStyle h4white() => TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontFamily: font,
      );

  TextStyle h1SpringGreen() => TextStyle(
        fontSize: 30,
        color: colorSpringGreen,
        fontFamily: font,
      );
  TextStyle h2SpringGreen() => TextStyle(
        fontSize: 25,
        color: colorSpringGreen,
        fontFamily: font,
      );
  TextStyle h3SpringGreen() => TextStyle(
        fontSize: 20,
        color: colorSpringGreen,
        fontFamily: font,
      );
  TextStyle h4SpringGreen() => TextStyle(
        fontSize: 15,
        color: colorSpringGreen,
        fontFamily: font,
      );

  TextStyle h1Red() => TextStyle(
        fontSize: 30,
        color: colorRed,
        fontFamily: font,
      );
  TextStyle h2Red() => TextStyle(
        fontSize: 25,
        color: colorRed,
        fontFamily: font,
      );
  TextStyle h3Red() => TextStyle(
        fontSize: 20,
        color: colorRed,
        fontFamily: font,
      );
  TextStyle h4Red() => TextStyle(
        fontSize: 15,
        color: colorRed,
        fontFamily: font,
      );
}
