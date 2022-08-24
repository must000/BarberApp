import 'package:barber/Constant/contants.dart';
import 'package:flutter/material.dart';

class AboutDeveloper extends StatefulWidget {
  const AboutDeveloper({Key? key}) : super(key: key);

  @override
  State<AboutDeveloper> createState() => _AboutDeveloperState();
}

class _AboutDeveloperState extends State<AboutDeveloper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Contants.myBackgroundColordark),
      backgroundColor: Contants.myBackgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "ผู้พัฒนา",
              style: Contants().h1white(),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Center(child: Text("Jitti Homklin" ,style: Contants().h3white(),)),
              subtitle: Center(child: Text("นายจิตติ หอมกลิ่น",style: Contants().h4white(),)),
            ),
            ListTile(
              title: Center(child: Text("Jeeraphat Thaveewattanamanont ",style: Contants().h3white(),)),
              subtitle: Center(child: Text("จีรภัทร์ ทวีวัฒนามานนท์ ",style: Contants().h4white(),)),
            )
          ],
        ),
      ),
    );
  }
}
