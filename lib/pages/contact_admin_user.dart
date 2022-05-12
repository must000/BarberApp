import 'package:flutter/material.dart';

class ContactAdminUser extends StatefulWidget {
  const ContactAdminUser({Key? key}) : super(key: key);

  @override
  State<ContactAdminUser> createState() => _ContactAdminUserState();
}

class _ContactAdminUserState extends State<ContactAdminUser> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          
          children: [
            const Text("ข้อมูลติดต่อ"),
            const Text("08X-XXX-XXXX"),
            const Text("xxxxxx@hotmail.com"),
            const Text("xxxxx@gmail.com"),
            Container(
              margin: EdgeInsets.all(size*0.2),
              height: 100,
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("ต้องการติดต่อแอดมิน\nทางช่องแชท")),
            )
          ],
        ),
      ),
    );
  }
}
