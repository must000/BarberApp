import 'package:barber/Constant/contants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: Text(
          "ช่องทางการติดต่อ",
          style: Contants().h1white(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              showCard(
                  "เบอร์โทร 08X-XXX-XXXX",
                  Icon(
                    Icons.phone,
                    color: Contants.colorOxfordBlue,
                  )),
              const SizedBox(height: 10),
              showCard(
                  "อีเมล xxxxxx@hotmail.com",
                  Icon(
                    Icons.email,
                    color: Contants.colorOxfordBlue,
                  )),
              const SizedBox(height: 10),
              showCard(
                  "จีเมล xxxxx@gmail.com",
                  FaIcon(
                  FontAwesomeIcons.google,
                  color: Contants.colorOxfordBlue,
                ),),
              const SizedBox(height: 10),

              showCard(
                "ไลน์ @ADMIN",
                FaIcon(
                  FontAwesomeIcons.line,
                  color: Contants.colorOxfordBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card showCard(String title, Widget icon) {
    return Card(
      child: ListTile(
          title: Text(
            title,
            style: Contants().h3OxfordBlue(),
          ),
          leading: icon),
    );
  }
}
