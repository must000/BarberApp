import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/album_barber.dart';
import 'package:barber/pages/Barbermanager/member_barber.dart';
import 'package:barber/pages/Barbermanager/setting_barber.dart';
import 'package:barber/pages/Barbermanager/statistics_barber.dart';
import 'package:barber/provider/myproviders.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../Constant/contants.dart';

class DrawerObject extends StatelessWidget {
  DrawerObject({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Contants.myBackgroundColor,
      child: Stack(
        children: [
          ListView(children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Contants.myBackgroundColor),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    "ร้าน ${barberModelformanager!.name}",
                    style: Contants().h3white(),
                  ),
                  CachedNetworkImage(
                    imageUrl: barberModelformanager!.url,
                    fit: BoxFit.cover,
                    height: 120,
                    placeholder: (context, url) =>
                        LoadingAnimationWidget.waveDots(
                            color: Contants.colorSpringGreen, size: 15),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.group,color: Contants.colorWhite,size: 34,),
              title: Text('ช่างทำผมของร้าน', style: Contants().h3white()),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MemberBarberPage()));
              },
            ),
            ListTile(
                           leading: Icon(Icons.store,color: Contants.colorWhite,size: 34,),
              title: Text('ข้อมูลร้าน', style: Contants().h3white()),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SettingBarber()));
              },
            ),
            ListTile(
                           leading: Icon(Icons.photo_library,color: Contants.colorWhite,size: 34,),
              title: Text('อัลบั้ม', style: Contants().h3white()),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlbumBarber(),
                    ));
              },
            ),
            ListTile(
                           leading: Icon(Icons.bar_chart,color: Contants.colorWhite,size: 34,),
              title: Text('ยอดผู้ใช้บริการ', style: Contants().h3white()),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StatisticeBarber()));
              },
            ),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                title: Text('ออกจากระบบ', style: Contants().h3Red()),
                onTap: () {
                  final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logoutBB(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
