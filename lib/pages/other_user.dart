import 'package:barber/provider/myproviders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constant/route_cn.dart';

class OtherUser extends StatefulWidget {
  const OtherUser({Key? key}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  
  @override
  Widget build(BuildContext context) {
    late final user = FirebaseAuth.instance.currentUser;
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: size * 0.08),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return user?.displayName == null
                            ? const Text("")
                            : Text(
                            user!.displayName!,
                            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 15),
                              );
                      } else if (snapshot.hasError) {
                        return Text("error");
                      } else {
                        return Text("");
                      }
                    },
                  ),
                  logout(context),
                  TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Rount_CN.routeLogin);
              },
              child: const Text("Login"))
                ],
              ),
              Container(
                child: const Text("คะแนนสะสม"),
                margin: const EdgeInsets.only(top: 10, bottom: 70),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("ตั้งค่าข้อมูลผู้ใช้"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("ต้องการเปิดร้านทำผม"),
              ),
              const SizedBox(
                height: 70,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("ขอความช่วยเหลือ"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("เกี่ยวกับเรา"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  logout(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logout();
        },
        child: const Text("logout"));
  }
}
