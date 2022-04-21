import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/login.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({ Key? key }) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          actions: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return user.displayName == null
                      ? const Text("")
                      : Text(user.displayName!);
                } 
                else if (snapshot.hasError){
                  return Text("error");
                }
                else {
                  return TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Rount_CN.routeLogin);
                      },
                      child: const Text("Login"));
                }
              },
            )
          ],
          backgroundColor: Colors.red,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("IndexPage"),
            ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<MyProviders>(context, listen: false);
                  provider.logout();
                },
                child: const Text("logout"))
          ],
        )));
  }
}