import 'package:flutter/material.dart';

class ReservationDetailUser extends StatefulWidget {
  const ReservationDetailUser({Key? key}) : super(key: key);

  @override
  State<ReservationDetailUser> createState() => _ReservationDetailUserState();
}

class _ReservationDetailUserState extends State<ReservationDetailUser> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("รายละเอียด")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Text("ชื่อร้าน"),
            Text("เวลาที่ใช้บริการ"),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("บริการที่ได้รับ"),
                Container(
                  width: size * 0.6,
                  child: ListView.builder(
                    shrinkWrap: true, //    <-- Set this to true
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Row(
                        children: const [Text("ตัดผม"), Text("50 บาท")],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      );
                    },
                    itemCount: 3,
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text("ยอดรวม 150 บาท"),
                    ],
                  ),
                  width: size * 0.6,
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text("คะแนนและความคิดเห็น"),
                ListTile(
                  title: Text("ชื่อUser"),
                  subtitle: Text("ดีเกินปุยมุ้ย ดีเกินปุยมุ้ยยยยยยยยยย"),
                  trailing: IconButton(
                      onPressed: () {}, icon: Icon(Icons.delete_outline_sharp,color: Colors.red,)),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
