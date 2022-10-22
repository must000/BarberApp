import 'package:barber/data/hairdressermodel.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:barber/Constant/contants.dart';

class MemberBarberPage extends StatefulWidget {
  MemberBarberPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MemberBarberPage> createState() => _MemberBarberPageState();
}

class _MemberBarberPageState extends State<MemberBarberPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMember();
  }

  List<HairdresserModel> member = [];
  Map<String, String> urlImageMember = {};
  Future<void> getMember() async {
    FirebaseFirestore.instance
        .collection('Hairdresser')
        .where("barberState", isEqualTo: barberModelformanager!.email)
        .get()
        .then((value) {
      List<HairdresserModel> data = [];
      for (var i = 0; i < value.docs.length; i++) {
        data.add(HairdresserModel(
            hairdresserID: value.docs[i].id,
            email: value.docs[i]["email"],
            idCode: value.docs[i]["idCode"],
            name: value.docs[i]["name"],
            lastname: value.docs[i]["lastname"],
            serviceID: value.docs[i]["serviceID"],
            barberStatus: value.docs[i]["barberState"],
            phone: value.docs[i]["phone"]));
      }
      print("1");
    getURL(data);
    });
  }
        Future<Null> getURL(List<HairdresserModel> data) async {
        Map<String, String>? urlimg = {};
         print("2");
        for (var i = 0; i < data.length; i++) {
           print("3");
          Reference ref =
              FirebaseStorage.instance.ref().child("avatar/${data[i].email}");
               print("4");
          var url = await ref.getDownloadURL().then((value) {
             print("5");
            urlimg[data[i].email] = value;
             print("6");
          }).catchError((c) => print(c + "is an error"));
        }
          
        setState(() {
          print("7");
          member = data;
          urlImageMember = urlimg;
        });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size * 0.7,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "code",
                      hintStyle: Contants().h4Grey(),
                    ),
                  ),
                ),
                Container(
                    width: size * 0.2,
                    child: ElevatedButton(
                      child: const Text("เพิ่ม"),
                      onPressed: () {},
                    ))
              ],
            ),
            member.isEmpty
                ? const SizedBox()
                : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        leading: CachedNetworkImage(
                            imageUrl: urlImageMember[member[index].email]!),
                        title: Text(
                          "${member[index].name} ${member[index].lastname}",style: Contants().h3OxfordBlue(),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete,color: Contants.colorRed,), onPressed: () {}),
                      ),
                    ),
                    itemCount: member.length,
                  ),
          ],
        ),
        drawer: DrawerObject());
  }
}
