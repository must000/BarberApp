import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class BanlistPage extends StatefulWidget {
  const BanlistPage({Key? key}) : super(key: key);

  @override
  State<BanlistPage> createState() => _BanlistPageState();
}

class _BanlistPageState extends State<BanlistPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  List<Map<String, String>> data1 = [];

  Future<Null> getdata() async {
    await FirebaseFirestore.instance
        .collection('Barber')
        .doc(barberModelformanager!.email)
        .collection("banlist")
        .get()
        .then((value) {
      List<Map<String, String>> data = [];
      for (var i = 0; i < value.docs.length; i++) {
        data.add(
          {
            "name": value.docs[i]["name"],
            "id": value.docs[i].id,
          },
        );
      }
      setState(() {
        data1 = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(
                data1[index]["name"].toString(),
                style: Contants().h3OxfordBlue(),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.do_not_disturb_on,
                    color: Contants.colorOxfordBlue,
                  ),
                  onPressed: () {
                    superDialog(context, "", "ปลดแบน", index);
                  }),
            ),
          ),
          itemCount: data1.length,
        ));
  }

  Future<Null> superDialog(
      BuildContext context, String string, String title, int index) async {
    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(title, style: const TextStyle(color: Colors.black)),
          subtitle: Text(string),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  fc(index);
                },
                child: Text(
                  "ยืนยัน",
                  style: Contants().h2OxfordBlue(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ยกเลิก", style: Contants().h2Red()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  fc(int index) {
    print(data1[index]["id"]);
    FirebaseFirestore.instance
        .collection("Barber")
        .doc(barberModelformanager!.email)
        .collection("banlist")
        .doc(data1[index]["id"])
        .delete()
        .then((value) {
      print("ลบสำเร็จ");
      Navigator.pop(context);
      getdata();
    });
  }
}
