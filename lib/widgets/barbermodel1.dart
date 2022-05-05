import 'package:flutter/material.dart';

class BarberModel1 extends StatelessWidget {
  double size;
  String? img, score;
  String nameBarber;
  bool? like = false;

  BarberModel1(
      {Key? key,
      required this.size,
      this.img,
      this.score,
      this.like,
      required this.nameBarber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(border: Border.all()),
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Container(
                height: 80,
                width: size * 0.35,
                child: Image.network(
                  img != null
                      ? img!
                      : "https://www.kosinstudio.com/wp-content/uploads/2020/06/Sleeve-badge-EPL-2017-Present.png",
                ),
              ),
              Container(
                child: Text(nameBarber),
                width: size * 0.3,
              ),
              Container(
                child: score != null
                    ? Text("คะแนนและรีวิว $score")
                    : Text("ยังไม่มีคะแนน"),
                width: size * 0.3,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size*0.25),
          child: IconButton(onPressed: (){}, icon: Icon(Icons.favorite,color: like == true? Colors.red:Colors.grey,)),
        )
      ]),
    );
  }
}
