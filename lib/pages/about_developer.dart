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
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: const [
            Text("ผู้พัฒนา"),
            Text("นายจิตติ หอมกลิ่น"),
            Text("นายจีรภัทร์ ทวีวัฒนามานนท์"),
          ],
        ),
      ),
    );
  }
}
