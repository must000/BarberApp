import 'package:barber/Constant/route_cn.dart';
import 'package:barber/pages/detail_barber_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BarberUser extends StatefulWidget {
  final String nameBarber;
  const BarberUser({
    Key? key,
    required this.nameBarber,
  }) : super(key: key);

  @override
  State<BarberUser> createState() =>
      _BarberUserState(nameBarber: nameBarber);
}

class _BarberUserState extends State<BarberUser> {
  String nameBarber;
  _BarberUserState({required this.nameBarber});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    late final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameBarber),
        actions: [
          buildUsername_Login(user),
        ],
      ),
      body: ListView(children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                height: size * 0.45,
                width: size * 0.6,
                child: Image.network(
                  "https://images.ctfassets.net/81iqaqpfd8fy/3r4flvP8Z26WmkMwAEWEco/870554ed7577541c5f3bc04942a47b95/78745131.jpg?w=1200&h=1200&fm=jpg&fit=fill",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: size * 0.1,
                      )),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailBarberUser(nameBarber: nameBarber) ));
                      },
                      child: const Text("ข้อมูลร้าน"),
                    ),
                  ),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("ผลงาน"),
                    ),
                  ),
                  Container(
                    width: size * 0.33,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("คะแนนและรีวิว"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          child: Text("รับตัดผมวินเทจ เกาหลี โดยยอดฝีมือ"),
          margin: const EdgeInsets.symmetric(horizontal: 15),
        ),
        const SizedBox(
          height: 50,
        ),
        ListView.builder(
          shrinkWrap: true, //    <-- Set this to true
          physics: ScrollPhysics(),
          itemBuilder: (context, index) => const Card(
            child: ListTile(
              title: Text("ชื่อรายการ"),
              subtitle: Text("รายละเอียด"),
              trailing: Text('30 นาที / 60 บาท'),
            ),
          ),
          itemCount: 10,
        )
      ]),
    );
  }

  StreamBuilder<User?> buildUsername_Login(User? user) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return user?.displayName == null
              ? const Text("")
              : Center(
                  child: Text(
                  user!.displayName!,
                  style: const TextStyle(color: Colors.white),
                ));
        } else if (snapshot.hasError) {
          return Text("error");
        } else {
          return TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Rount_CN.routeLogin);
              },
              child: const Text("Login"));
        }
      },
    );
  }
}
