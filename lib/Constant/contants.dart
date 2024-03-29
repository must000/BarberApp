import 'package:flutter/material.dart';

class Contants {
  static String keyLongdomap = "f347b56e94df23bde1dd8d0fc4bfa954";
  static String bundleID =
      "localhost,*,console.firebase.google.com/project/barberapp-d8c95";

  static Color colorOxfordBlue = const Color(0xff14213D);
  static Color colorOxfordBlueLight = const Color.fromARGB(255, 35, 55, 99);
  static Color colorSpringGreen = const Color(0xff00FF66);
  static Color colorYellow = Color(0xffFCA311);
  static Color colorYellowdark = Color.fromARGB(255, 172, 106, 1);
  static Color colorBlack = const Color(0xff1C1919);
  static Color colorRed = const Color(0xffFF0000);
  static Color colorGreySilver = const Color(0xffA0A0A0);
  static Color colorWhite = const Color.fromARGB(255, 255, 255, 255);

  static Color myBackgroundColor = const Color(0xff14213D);
  static Color myBackgroundColordark = colorBlack;

  String font = 'Itim';
  TextStyle floatingLabelStyle() => TextStyle(
        fontSize: 25,
        color: colorWhite,
        fontFamily: font,
      );
  static Color filecolors = const Color(0xff14213D);
   OutlineInputBorder outlineenable()=> OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Contants.colorGreySilver),
      );
  OutlineInputBorder outlinefocused()=> OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Contants.colorSpringGreen),
      );

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
  TextStyle h1Grey() => TextStyle(
        fontSize: 30,
        color: colorGreySilver,
        fontFamily: font,
      );
  TextStyle h2Grey() => TextStyle(
        fontSize: 25,
        color: colorGreySilver,
        fontFamily: font,
      );
  TextStyle h3Grey() => TextStyle(
        fontSize: 20,
        color: colorGreySilver,
        fontFamily: font,
      );
  TextStyle h4Grey() => TextStyle(
        fontSize: 15,
        color: colorGreySilver,
        fontFamily: font,
      );
  TextStyle h1yellow() => TextStyle(
        fontSize: 30,
        color: colorYellow,
        fontFamily: font,
      );
  TextStyle h2yellow() => TextStyle(
        fontSize: 25,
        color: colorYellow,
        fontFamily: font,
      );
  TextStyle h3yellow() => TextStyle(
        fontSize: 20,
        color: colorYellow,
        fontFamily: font,
      );
  TextStyle h4yellow() => TextStyle(
        fontSize: 15,
        color: colorYellow,
        fontFamily: font,
      );
}
