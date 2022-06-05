import 'package:barber/pages/barberserch_user.dart';
import 'package:barber/pages/test.dart';
import 'package:barber/widgets/barbermodel1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Constant/route_cn.dart';

class HairCutUser extends StatefulWidget {
  const HairCutUser({Key? key}) : super(key: key);

  @override
  State<HairCutUser> createState() => _HairCutUserState();
}

class _HairCutUserState extends State<HairCutUser> {
  String? name, email, phone;
  @override
  void initState() {
    super.initState();
    findNameAnEmail();
  }


  Future<Null> findNameAnEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          name = event!.displayName!;
          email = event.email!;
          phone = event.phoneNumber;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    late final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          FirebaseAuth.instance.currentUser != null
              ? Center(
                  child: Text(name == null
                      ? ""
                      : name == ""
                          ? email.toString()
                          : "$name"))
              : TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Rount_CN.routeLogin);
                  },
                  child: const Text("Login"))
        ],
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Test(),));
            }, child: Text("ssasaw")),
            buttonChooseAType(size),
            sectionListview(size, "ร้านที่เคยใช้บริการ"),
            listStoreHistory(size),
            sectionListview(size, "ร้านที่ถูกใจ"),
            listStoreLike(size),
          ],
        ),
      ),
    );
  }

  Container listStoreLike(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 180,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) => BarberModel1(
                  size: size,
                  nameBarber: "ร้านที่ถูกใจ",
                )),
      ),
    );
  }

  Container listStoreHistory(double size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 180,
      child: Expanded(
        flex: 3,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) => BarberModel1(
                  size: size,
                  nameBarber: "ชื่อร้าน",
                  img:
                      "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
                )),
      ),
    );
  }

  Container sectionListview(double size, String title) {
    return Container(
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      width: size,
      padding: EdgeInsets.symmetric(horizontal: size * 0.1),
    );
  }

  Container buttonChooseAType(double size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BarberSerchUser(
                                typeBarber: true,
                              )));
                },
                child: const Text("ร้านตัดผมชาย")),
            width: size * 0.4,
            height: 50,
          ),
          SizedBox(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BarberSerchUser(
                                typeBarber: false,
                              )));
                },
                child: const Text("ร้านเสริมสวย")),
            width: size * 0.4,
            height: 50,
          )
        ],
      ),
    );
  }
  //  StreamBuilder<User?> buildUsername_Login(User? user) {
  //   return StreamBuilder(
  //     stream: FirebaseAuth.instance.authStateChanges(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.hasData) {
  //         return user?.displayName == null
  //             ? const Text("")
  //             : Center(child: Text("ชื่อผู้ใช้"+user!.displayName!,style: const TextStyle(color: Colors.white),));
  //       } else if (snapshot.hasError) {
  //         return Text("error");
  //       } else {
  //         return TextButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, Rount_CN.routeLogin);
  //             },
  //             child: const Text("Login"));
  //       }
  //     },
  //   );
  // }
}
