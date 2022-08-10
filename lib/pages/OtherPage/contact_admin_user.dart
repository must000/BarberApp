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
          
          children: const [
            Text("ข้อมูลติดต่อ"),
            Text("08X-XXX-XXXX"),
            Text("xxxxxx@hotmail.com"),
            Text("xxxxx@gmail.com"),
          ],
        ),
      ),
    );
  }
}
