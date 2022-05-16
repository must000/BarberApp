import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/index.dart';
import 'package:barber/pages/registerbarber.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var loading = false;
  void _loginwithfacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      Navigator.pushNamedAndRemoveUntil(
          context, Rount_CN.routeIndex, (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          title = 'Unknown error has occurred';
          break;
        case 'user-disabled':
          title = 'The user you tried to log intp is disabled';
          break;
        case 'user-not-found':
          title = 'The user you tried to log into was not found';
          break;
      }
      // normalDialog(context, title);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(
                FocusNode(),
              ), //กดที่หน้าจอ แ้ล้วคีย์อบร์ดดรอปลง
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: size * 0.1, vertical: size * 0.25),
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
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
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
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              authen();
                            }
                          },
                          child: const Text("Login")),
                      const Text('register'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: size * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Rount_CN.routeRegisterUser);
                              },
                              child: const Text("ลูกค้า"),
                            ),
                          ),
                          Container(
                            width: size * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterBarber()),
                                );
                              },
                              child: const Text("ช่างตัดผม"),
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final provider = Provider.of<MyProviders>(context,
                                listen: false);
                            provider.googleLogin().then((value) =>
                                Navigator.pushNamedAndRemoveUntil(context,
                                    Rount_CN.routeIndex, (route) => false));
                          },
                          icon: const FaIcon(FontAwesomeIcons.google),
                          label: const Text('Google'),
                        ),
                        width: size * 0.7,
                      ),
                      Container(
                        child: ElevatedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.facebook),
                          onPressed: () {
                            _loginwithfacebook();
                          },
                          label: const Text('Facebook'),
                        ),
                        width: size * 0.7,
                      )
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
          .catchError((value) {MyDialog().normalDialog(context, value.message);} );
    });
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
