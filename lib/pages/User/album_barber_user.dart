import 'package:barber/Constant/contants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlbumBarberUser extends StatefulWidget {
  String email;
  AlbumBarberUser({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<AlbumBarberUser> createState() => _AlbumBarberUserState(email: email);
}

class _AlbumBarberUserState extends State<AlbumBarberUser> {
  String email;
  _AlbumBarberUserState({required this.email});
  List<Map<String, dynamic>>? filess = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlbumUrl();
  }

  bool load = true;

  Future<Null> getAlbumUrl() async {
    final ListResult result =
        await FirebaseStorage.instance.ref().child('album').child(email).list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);
    List<Map<String, dynamic>> files = [];
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      files.add({
        'url': fileUrl,
        'path': file.fullPath,
        'status': false,
      });
      print(files);
    });
    setState(() {
      filess = files;
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Contants.myBackgroundColor,
      appBar: AppBar( backgroundColor: Contants.myBackgroundColordark,),
      body:load
            ? Center(
              child: LoadingAnimationWidget.waveDots(
                  color: Contants.colorSpringGreen, size: 50),
            )
            :  filess!.isEmpty
          ? Center(
              child: Text("ไม่มีรูปภาพในอัลบั้ม",style: Contants().h2SpringGreen(),),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: CachedNetworkImage(
                      imageUrl: filess![index]['url'].toString()),
                );
              },
              itemCount: filess!.length,
            ),
    );
  }
}
