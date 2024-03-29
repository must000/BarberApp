import 'dart:async';

import 'package:barber/Constant/route_cn.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/pages/Authentication/registeruser.dart';
import 'package:barber/pages/OtherPage/about_developer.dart';
import 'package:barber/pages/OtherPage/contact_admin_user.dart';
import 'package:barber/pages/icon_page.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/pages/Authentication/login.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<BarberModel> barberLike = [];
Map<String, String> urlImgLike = {};
BarberModel? barberModelformanager;

StreamController<BarberModel> streamController2 =
    StreamController<BarberModel>.broadcast();
final Map<String, WidgetBuilder> map = {
  '/Login': (BuildContext context) => const Login(),
  '/index': (BuildContext context) => IndexPage(),
  '/registerUser': (BuildContext context) => const RegisterUser(),
  '/contactAdminUser': (BuildContext context) => const ContactAdminUser(),
  '/aboutDevloper': (BuildContext context) => const AboutDeveloper(),
  '/iconpage': (BuildContext context) => const IconAppPage(),
};
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyProviders(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.black,
            checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.all(Colors.white),
            )),
        routes: map,
        initialRoute: '/index',
      ),
    );
  }
}
