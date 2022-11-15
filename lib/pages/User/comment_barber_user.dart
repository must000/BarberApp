import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:barber/data/commentmodel.dart';

import '../../Constant/contants.dart';

class CommentBarberUser extends StatefulWidget {
  String emailbarber;
  String url;
  String nameBarber;
  CommentBarberUser({
    Key? key,
    required this.emailbarber,
    required this.url,
    required this.nameBarber,
  }) : super(key: key);

  @override
  State<CommentBarberUser> createState() => _CommentBarberUserState(
      emailbarber: emailbarber, nameBarber: nameBarber, url: url);
}

class _CommentBarberUserState extends State<CommentBarberUser> {
  String emailbarber;
  String url;
  String nameBarber;
  _CommentBarberUserState(
      {required this.emailbarber, required this.nameBarber, required this.url});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComment();
  }

  double? average;
  List<CommentModel> listcomment = [];
  Future<Null> getComment() async {
    var queryS = await FirebaseFirestore.instance
        .collection("Queue")
        .where("comment.show",isEqualTo: true)
        .where("barber.id", isEqualTo: emailbarber)
        .get();
    var alldata2 = queryS.docs.map((e) => e.data()).toList();
    List<CommentModel> dataEx2 = [];
    double x = 0;
    if (alldata2.isNotEmpty) {
      for (int n = 0; n < alldata2.length; n++) {
        dataEx2.add(CommentModel(
            comment: alldata2[n]["comment"]["message"],
            score: alldata2[n]["comment"]["score"]));
        x += alldata2[n]["comment"]["score"].toDouble();
      }
      x = x / alldata2.length;
      setState(() {
        average = x;
        listcomment = dataEx2;
      });
    } else {
      print("ไม่มีคอมเมนต์");
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar(
        backgroundColor: Contants.myBackgroundColordark,
        title: const Text("คะแนนและรีวิว"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size * 0.03),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "ร้าน : $nameBarber",
                    style: Contants().h2white(),
                  ),
                  const SizedBox()
                ],
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (context, url) =>
                        LoadingAnimationWidget.waveDots(
                            size: 10, color: Contants.colorSpringGreen),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageBuilder: (context, imageProvider) => Container(
                      width: size * 0.50,
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  SizedBox(width: size * 0.05),
                  average == null
                      ? Text(
                          "-",
                          style: Contants().h1white(),
                        )
                      : Text(
                          average!.toStringAsFixed(1),
                          style: Contants().h1white(),
                        ),
                  Icon(
                    Icons.star,
                    size: 50,
                    color: Contants.colorYellow,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              listcomment.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text(
                          "ยังไม่มีความคิดเห็น",
                          style: Contants().h3white(),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listcomment.length,
                      itemBuilder: (context, index) => Card(
                        color: Contants.colorGreySilver,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),)),
                        child: ListTile(
                          leading:  Icon(Icons.forum,size: 35,color: Contants.colorOxfordBlue,),
                          title: Text(listcomment[index].comment),
                          subtitle: Wrap(children: [
                            Icon(
                                listcomment[index].score > 0
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,size:30,),
                            Icon(
                                listcomment[index].score > 1
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,size:30),
                            Icon(
                                listcomment[index].score > 2
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,size:30),
                            Icon(
                                listcomment[index].score > 3
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,size:30),
                            Icon(
                                listcomment[index].score > 4
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,size:30),
                          ]),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
