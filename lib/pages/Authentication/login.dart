import 'package:barber/Constant/contants.dart';
import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/Authentication/chose_type.dart';
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

  // void _loginwithfacebook() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   try {
  //     final facebookLoginResult = await FacebookAuth.instance.login();
  //     final userData = await FacebookAuth.instance.getUserData();
  //     final facebookAuthCredential = FacebookAuthProvider.credential(
  //         facebookLoginResult.accessToken!.token);
  //     await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, Rount_CN.routeIndex, (route) => false);
  //   } on FirebaseAuthException catch (e) {
  //     var title = '';
  //     switch (e.code) {
  //       case 'account-exists-with-different-credential':
  //         title = 'This account exists with a different sign in provider';
  //         break;
  //       case 'invalid-credential':
  //         title = 'Unknown error has occurred';
  //         break;
  //       case 'user-disabled':
  //         title = 'The user you tried to log intp is disabled';
  //         break;
  //       case 'user-not-found':
  //         title = 'The user you tried to log into was not found';
  //         break;
  //     }
  //     // normalDialog(context, title);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

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
                    horizontal: size * 0.1, vertical: size * 0.10),
                child: Form(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "กรุณากรอกอีเมล";
                            } else {}
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "กรุณากรอกรหัสผ่าน";
                            } else {}
                          },
                          obscureText: statusRedEys,
                          controller: passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
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
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30)),
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
                        height: 50,
                      ),
                      const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: size * 0.35,
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size * 0.35,
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
                                      builder: (context) =>
                                          const ChoseType()),
                                );
                              },
                              child: const Text(
                                "ร่วมงานกับเรา ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          signInWithFacebook()
                              .then((value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IndexPage(),
                                  ),
                                  (route) => false));
                        },
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.facebook,
                                  size: 60,
                                  color: Colors.blue,
                                ),
                                Text(
                                  "เข้าสู่ระบบด้วย Facebook",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white)),
                      ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                  size: 60,
                                ),
                                Text(
                                  "เข้าสู่ระบบด้วย Google",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white)),
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
              email: emailController.text, password: passwordController.text)
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, Rount_CN.routeIndex, (route) => false))
          .catchError((value) {
        MyDialog().normalDialog(context, value.message);
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
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
//  Future loginWithFacebook(BuildContext context) async {
//    final LoginResult result = await FacebookAuth.instance.login();
//     if (result.status == LoginStatus.success) {
//       _accessToken = result.accessToken;

//       final userData = await FacebookAuth.instance.getUserData();
//       _userData = userData;
//     } else {
//       print(result.status);
//       print(result.message);
//     }
//     setState(() {
//       _checking = false;
//     });
// }

}
