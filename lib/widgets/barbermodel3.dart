import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        decoration: BoxDecoration(
          border: Border.all(color: Contants.colorWhite, width: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => LoadingAnimationWidget.inkDrop(
                      color: Colors.black, size: 20),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 90,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "${barberModel.shopname}  ",
                    style: Contants().h4white(),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      barberModel.score == 0 || barberModel.score.isNaN
                          ? "-"
                          : barberModel.score.toStringAsFixed(2),
                      style: Contants().h4yellow(),
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
