import 'package:barber/Constant/contants.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:flutter/material.dart';

class StatisticeBarber extends StatefulWidget {
  const StatisticeBarber({Key? key}) : super(key: key);

  @override
  State<StatisticeBarber> createState() => _StatisticeBarberState();
}

class _StatisticeBarberState extends State<StatisticeBarber> {
  bool clickList = true;
  int clickListIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReservation();
  }
  getReservation(){

  }
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          clickList = true;
                        });
                      },
                      child: Text(
                        "การจอง",
                        style: clickList
                            ? Contants().h3yellow()
                            : Contants().h3Grey(),
                      )),
                  width: size * 0.5,
                ),
                Container(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          clickList = false;
                        });
                      },
                      child: Text("กราฟ",
                          style: clickList == false
                              ? Contants().h3yellow()
                              : Contants().h3Grey())),
                  width: size * 0.5,
                ),
              ],
            ),
            clickList
                ? buildListReseve()
                : Column(
                    children: const [Text("กราฟ")],
                  )
          ],
        ),
        drawer: DrawerObject());
  }

  Column buildListReseve() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 1;
                });
              },
              child: Text(
                "ปี",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 1
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 2;
                });
              },
              child: Text(
                "เดือน",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 2
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  clickListIndex = 3;
                });
              },
              child: Text(
                "วัน",
                style: Contants().h3OxfordBlue(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    clickListIndex == 3
                        ? Contants.colorSpringGreen
                        : Contants.colorGreySilver),
              ),
            )
          ],
        ),
        clickListIndex == 1
            ? Text("ปี")
            : clickListIndex == 2
                ? Text("เดือน")
                : Text('วัน')
      ],
    );
  }
}
