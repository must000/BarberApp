import 'package:barber/Constant/contants.dart';
import 'package:barber/data/barbermodel.dart';
import 'package:barber/pages/User/barber_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BarberModel2 extends StatelessWidget {
  String nameUser;
  BarberModel barberModel;
  String url;
  double score;
  double size;
  BarberModel2(
      {required this.nameUser,
      required this.barberModel,
      required this.url,
      required this.score,
      required this.size,
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
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            border: Border.all(color: Contants.colorWhite, width: 1)),
        child: Column(
          children: [
            CachedNetworkImage(
              height: 120,
              width: size * 0.9,
              fit: BoxFit.fitWidth,
              imageUrl: url,
              placeholder: (context, url) =>
                  LoadingAnimationWidget.inkDrop(color: Colors.black, size: 30),
            ),
            ListTile(
                title: Text(
                  "${barberModel.shopname} ",
                  style: Contants().h2white(),
                ),
                subtitle: Wrap(
                  direction: Axis.vertical,
                  children: [
                    Text(
                      barberModel.shoprecommend,
                      style: Contants().h4Grey(),
                    ),
                    Text(
                        "ร้านเปิด ${barberModel.timeopen} - ${barberModel.timeclose}",
                        style: Contants().h4Grey()),
                    Row(
                      children: [
                        Icon(
                          Icons.pin_drop_sharp,
                          color: Contants.colorGreySilver,
                          size: 18,
                        ),
                        Text(
                          "${barberModel.subDistrict} ${barberModel.addressdetails}",
                          style: Contants().h4Grey(),
                        )
                      ],
                    )
                  ],
                ),
                trailing: Wrap(
                  direction: Axis.horizontal,
                  children: [
     
                    Column(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                                       score == 0 || score.isNaN
                        ? Text(
                            "-",
                            style: Contants().h4yellow(),
                          )
                        : Text(
                            "คะแนน ${score.toStringAsFixed(2)} ",
                            style: Contants().h4yellow(),
                          ),
                      ],
                    ),
                   
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
