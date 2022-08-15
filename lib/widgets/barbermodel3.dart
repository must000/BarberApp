import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/data/sqlite_model.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:barber/utils/sqlite_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BarberModel3 extends StatelessWidget {
  String nameUser;
  BarberModel barberModel;
  String url;
  BarberModel3(
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
              url: url,
              barberModel: barberModel,
            ),
          ),
        );
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Contants.colorWhite)),
        child: Column(
          children: [
            CachedNetworkImage(
              height: 70,
              fit: BoxFit.fill,
              imageUrl: url,
              placeholder: (context, url) =>
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 20),
            ),
            Center(
              child: Text(
                barberModel.shopname,
                style: Contants().h4white(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text("5"),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "X",
                        style: Contants().h4white(),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
