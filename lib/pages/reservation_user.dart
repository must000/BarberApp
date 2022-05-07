import 'package:barber/pages/reservation_detail_user.dart';
import 'package:flutter/material.dart';

class ReservationUser extends StatefulWidget {
  const ReservationUser({Key? key}) : super(key: key);

  @override
  State<ReservationUser> createState() => _ReservationUserState();
}

class _ReservationUserState extends State<ReservationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Center(
            child: Text(
          "การจองของคุณ",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        )),
        elevation: 0,
        backgroundColor: Color.fromARGB(68, 250, 246, 246),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => InkWell(
          onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReservationDetailUser(),
                          ),
                        ),
          child: const Card(
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text("ชื่อร้าน ราคา"),
              subtitle: Text("เวลา 17-00.19.00"),
            ),
          ),
        ),
      ),
    );
  }
}
