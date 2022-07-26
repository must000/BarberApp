import 'package:barber/pages/barber_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/data/barbermodel.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchResultUser extends StatefulWidget {
  List<BarberModel> barberModel;
  String nameUser;
  SearchResultUser({
    Key? key,
    required this.barberModel,
    required this.nameUser,
  }) : super(key: key);

  @override
  State<SearchResultUser> createState() =>
      _SearchResultUserState(barberModel: barberModel,nameUser: nameUser);
}

class _SearchResultUserState extends State<SearchResultUser> {
  List<BarberModel> barberModel;
  String nameUser;
  _SearchResultUserState({required this.barberModel,required this.nameUser});
  Map<String, String>? urlImgFront;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getURL();
  }

  Future<Null> getURL() async {
    Map<String, String>? urlImgFrontModel = {};
    for (var i = 0; i < barberModel.length; i++) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("imgfront/${barberModel[i].email}");
      var url = await ref.getDownloadURL().then((value) {
        urlImgFrontModel[barberModel[i].email] = value;
      }).catchError((c) => print(c + "is an error"));
    }
    setState(() {
      urlImgFront = urlImgFrontModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: urlImgFront == null ? Container() : GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          
          shrinkWrap: true,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height/1.3),
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarberUser(
                      nameUser: nameUser,
                      email: barberModel[index].email,
                      nameShop: barberModel[index].shopname,
                      url: urlImgFront![barberModel[index].email]!,
                      recommend: barberModel[index].shoprecommend,
                      addressdetails: barberModel[index].addressdetails,
                      dayopen: barberModel[index].dayopen,
                      lat: barberModel[index].lat,
                      lon: barberModel[index].lng,
                      phoneNumber: barberModel[index].phone,
                      timeopen: barberModel[index].timeopen,
                      timeclose: barberModel[index].timeclose,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 60,
                        fit: BoxFit.fill,
                        imageUrl: urlImgFront![barberModel[index].email]!,
                        placeholder: (context, url) =>
                            LoadingAnimationWidget.inkDrop(
                                color: Colors.black, size: 20),
                      ),
                      ListTile(
                        title: Text(barberModel[index].shopname),
                        subtitle: Text(barberModel[index].shoprecommend),
                      ),
                      Row(
                        children: const [Text("คะแนน X "), Icon(Icons.star)],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: barberModel.length,
        ),
      ),
    );
  }
}
