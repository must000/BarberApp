import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/pages/barber_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BarberModel2 extends StatelessWidget {
  String nameUser;
  BarberModel barberModel;
  String url;
  BarberModel2(
      {required this.nameUser,
      required this.barberModel,
      required this.url,
      Key? key,
      this.funcAction,
      this.like})
      : super(key: key);
  bool? like;
  final Function()? funcAction;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarberUser(
              nameUser: nameUser,
              email: barberModel.email,
              nameShop: barberModel.shopname,
              url: url,
              recommend: barberModel.shoprecommend,
              addressdetails: barberModel.addressdetails,
              dayopen: barberModel.dayopen,
              lat: barberModel.lat,
              lon: barberModel.lng,
              phoneNumber: barberModel.phone,
              timeopen: barberModel.timeopen,
              timeclose: barberModel.timeclose,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: ListView(
          children: [
            CachedNetworkImage(
              height: 110,
              fit: BoxFit.fill,
              imageUrl: url,
              placeholder: (context, url) =>
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 20),
            ),
            ListTile(
              title: Text(
                barberModel.shopname,
                style: const TextStyle(fontSize: 30),
              ),
              subtitle: Text(barberModel.shoprecommend),
              trailing: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: like == true ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      SQLiteModel sqLiteModel =
                          SQLiteModel(email: barberModel.email);
                      await SQLiteHelper().insertValueToSQlite(sqLiteModel);
                    },
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Row(
                children: const [Text("คะแนน X "), Icon(Icons.star)],
              ),
            )
          ],
        ),
      ),
    );
  }
}