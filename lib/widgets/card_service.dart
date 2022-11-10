import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Constant/contants.dart';

class CardService extends StatelessWidget {
  var userData;
  CardService({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Contants.colorOxfordBlueLight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: ListTile(
            title: Text(
              userData['name'],
              style: Contants().h2white(),
            ),
            subtitle: Wrap(children: [
              Text(
                userData['detail'],
                style: Contants().h3Grey(),
              ),
              Divider(
                color: Contants.colorYellow,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Wrap(
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.payments,
                        color: Contants.colorSpringGreen,
                      ),
                      Text(
                        "${userData['price'].toStringAsFixed(0)} บาท",
                        style: Contants().h3Grey(),
                      ),
                      Icon(
                        Icons.schedule,
                        color: Contants.colorSpringGreen,
                      ),
                      Text(
                        "${userData['time'].toStringAsFixed(0)} นาที",
                        style: Contants().h3Grey(),
                      ),
                    ],
                  ),
                ],
              )
            ]),
          ),
        ));
  }
}
