import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/Authentication/chose_type.dart';
import 'package:barber/pages/Authentication/insert_position_barber.dart';
import 'package:barber/pages/Authentication/register_phone_user.dart';
import 'package:barber/pages/Authentication/registerhairdresser.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'com.facebook.FacebookSdk';
// import 'com.facebook.appevents.AppEventsLogger';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool statusRedEys = true;

  var loading = false;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Contants.colorOxfordBlue,
      ),
      backgroundColor: Contants.colorOxfordBlue,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(
                FocusNode(),
              ), //กดที่หน้าจอ แล้วคีย์อบร์ดดรอปลง
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size * 0.1, vertical: size * 0.02),
                child: Form(
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset("images/iconapp.png"),
                        width: size * 0.7,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: Contants().h3white(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "กรุณากรอกอีเมล";
                            } else {}
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "อีเมล",
                            fillColor: Contants.colorOxfordBlue,
                            labelStyle: Contants().floatingLabelStyle(),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Contants.colorGreySilver),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Contants.colorSpringGreen),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          style: Contants().h3white(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "กรุณากรอกรหัสผ่าน";
                            } else {}
                          },
                          obscureText: statusRedEys,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  statusRedEys = !statusRedEys;
                                });
                              },
                              icon: statusRedEys
                                  ? const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.black,
                                    ),
                            ),
                            labelText: "รหัสผ่าน",
                            fillColor: Contants.colorOxfordBlue,
                            labelStyle: Contants().floatingLabelStyle(),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Contants.colorGreySilver),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Contants.colorSpringGreen),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: size * 0.40,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authen();
                              }
                            },
                            child: const Text(
                              "เข้าสู่ระบบ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 23),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size * 0.37,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Rount_CN.routeRegisterUser);
                              },
                              child: const Text(
                                "ลูกค้า",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size * 0.37,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ChoseType()),
                                );
                              },
                              child: const Text(
                                "ร่วมงานกับเรา ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    
                      // InkWell(
                      //   onTap: () {
                      //     signInWithFacebook()
                      //         .then((value) => Navigator.pushAndRemoveUntil(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => IndexPage(),
                      //             ),
                      //             (route) => false));
                      //   },
                      //   child: Container(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: const [
                      //           FaIcon(
                      //             FontAwesomeIcons.facebook,
                      //             size: 60,
                      //             color: Colors.blue,
                      //           ),
                      //           Text(
                      //             "เข้าสู่ระบบด้วย Facebook",
                      //             style: TextStyle(
                      //                 fontSize: 20, color: Colors.black),
                      //           )
                      //         ],
                      //       ),
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(30),
                      //           color: Colors.white)),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          final provider =
                              Provider.of<MyProviders>(context, listen: false);
                          provider.googleLogin().then((value) =>
                              Navigator.pushNamedAndRemoveUntil(context,
                                  Rount_CN.routeIndex, (route) => false));
                        },
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.google,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "เข้าสู่ระบบด้วย Google",
                                    style: Contants().h3OxfordBlue(),
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white)),
                      ), const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> authen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.toLowerCase(),
              password: passwordController.text)
          .then(
            (value) => Navigator.pushNamedAndRemoveUntil(
                context, Rount_CN.routeIndex, (route) => false),
          )
          .catchError((value) {
        MyDialog().normalDialog(context, "อีเมลหรือรหัสผ่าน ไม่ถูกต้อง");
      });
    });
  }

  Future<Null> signInWithFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await FirebaseFirestore.instance.collection('users').add({
        'email': userData["email"],
        'inageUrl': userData['picture']['data']['url'],
        'name': userData['name']
      });
    } on FirebaseAuthException catch (e) {
      var title = e;
      MyDialog().normalDialog(context, "$e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<Future<UserCredential>> test() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
