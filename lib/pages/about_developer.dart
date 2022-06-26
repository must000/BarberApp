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
             SizedBox(height:50 ,),
            Text("ผู้พัฒนา",style: TextStyle(fontSize: 30),),
            SizedBox(height: 30,),
            ListTile(title: Center(child: Text("Jitti Homklin")),subtitle: Center(child: Text("นายจิตติ หอมกลิ่น")),),
            ListTile(title: Center(child: Text("Jeeraphat Thaveewattanamanont")),subtitle: Center(child: Text("จีรภัทร์ ทวีวัฒนามานนท์ ")),)
          ],
        ),
      ),
    );
  }
}
