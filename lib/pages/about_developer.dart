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
      body: ListView(
        children: const [
          Center(child: Text("ผู้พัฒนา")),
          Center(child: Text("นายจิตติ หอมกลิ่น")),
          Center(child: Text("นายจีรภัทร์ ทวีวัฒนามานนท์")),
        ],
      ),
    );
  }
}
