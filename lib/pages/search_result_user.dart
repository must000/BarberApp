import 'package:barber/pages/barber_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:barber/data/barbermodel.dart';

class SearchResultUser extends StatefulWidget {
  List<BarberModel> barberModel;
  SearchResultUser({
    Key? key,
    required this.barberModel,
  }) : super(key: key);

  @override
  State<SearchResultUser> createState() =>
      _SearchResultUserState(barberModel: barberModel);
}

class _SearchResultUserState extends State<SearchResultUser> {
  List<BarberModel> barberModel;
  _SearchResultUserState({required this.barberModel});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BarberUser(
                      email: barberModel[index].email,
                      nameShop: barberModel[index].shopname,
                      url: "",
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
                      // CachedNetworkImage(
                      //   height: 60,
                      //   fit: BoxFit.fill,
                      //   imageUrl: urlImgFront![
                      //       barberResult![index].email]!,
                      //   placeholder: (context, url) =>
                      //       LoadingAnimationWidget.inkDrop(
                      //           color: Colors.black, size: 20),
                      // ),
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
