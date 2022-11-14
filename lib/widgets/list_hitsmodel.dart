import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/data/barbermodel.dart';
import 'package:barber/widgets/barbermodel2.dart';

class ListHitsModek extends StatelessWidget {
  List<BarberModel> lists;
  double size;
  String nameUser;
  ListHitsModek({
    Key? key,
    required this.lists,
    required this.size,
    required this.nameUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    lists.sort((first, second) {
      return second.score.compareTo(first.score);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return BarberModel2(
            nameUser: nameUser,
            barberModel: lists[index],
            url: lists[index].url,
            score: lists[index].score,
            size: size,
          );
        },
        itemCount: lists.length,
      ),
    );
  }
}
