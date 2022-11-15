import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:barber/Constant/contants.dart';
import 'package:barber/main.dart';
import 'package:barber/pages/Barbermanager/drawerobject.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AlbumBarber extends StatefulWidget {
  const AlbumBarber({Key? key}) : super(key: key);

  @override
  State<AlbumBarber> createState() => _AlbumBarberState();
}

class _AlbumBarberState extends State<AlbumBarber> {
  List<Map<String, dynamic>>? filess = [];
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAlbumUrl();
  }

  int stackClick = 0;
  Future<Null> getAlbumUrl() async {
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('album')
        .child(barberModelformanager!.email)
        .list();
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
    });
    setState(() {
      filess = files;
      load = false;
    });
  }

  final ImagePicker imgpicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Contants.myBackgroundColordark,
          actions: [
            stackClick > 0
                ? IconButton(
                    onPressed: () {
                      MyDialog(funcAction: fc2).superDialog(
                          context,
                          "คุณต้องการจะลบรูปภาพ ทั้ง $stackClick นี้ หรือไม่",
                          "ยืนยันการลบ");
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      normalDialogForAlbum(context);
                    },
                    icon: const Icon(Icons.add),
                  )
          ],
        ),
        backgroundColor: Contants.myBackgroundColor,
        body: load
            ? LoadingAnimationWidget.waveDots(
                color: Contants.colorSpringGreen, size: 30)
            : filess!.isEmpty
                ? Center(
                    child: Text(
                      "ไม่มีรูปภาพในอัลบั้ม",
                      style: Contants().h2SpringGreen(),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: filess![index]['status'] == true
                                ? const BorderSide(color: Colors.red, width: 5)
                                : const BorderSide(
                                    color: Colors.black, width: 1),
                          ),
                          child: CachedNetworkImage(
                              imageUrl: filess![index]['url'].toString()),
                        ),
                        onTap: () {
                          setState(() {
                            if (filess![index]['status']) {
                              filess![index]['status'] = false;
                              stackClick--;
                            } else {
                              filess![index]['status'] = true;
                              stackClick++;
                            }
                            print(stackClick);
                          });
                        },
                      );
                    },
                    itemCount: filess!.length,
                  ),
        drawer: DrawerObject());
  }

  Future<Null> normalDialogForAlbum(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  selectImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () {
                  selectImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.collections_outlined,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  File? img;
  Future<void> selectImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
      );
      img = File(result!.path);
      MyDialog(funcAction: fc).confirmImage(context, img!);
    } catch (e) {}
  }

  void fc() {
    uploadImgAlbum(barberModelformanager!.email, img!).then((value) {
      Navigator.pop(context);
    });
  }

  void fc2() {
    deleteImage();
  }

  Future<Null> deleteImgAlbum() async {
    for (var i = 0; i < filess!.length; i++) {
      if (filess![i]["status"] == true) {
        //ถ้าเจอtrue ให้ลบ
        final storageRef = FirebaseStorage.instance.ref();
        final desertRef = storageRef.child(filess![i]["path"]);
        await desertRef.delete();
      }
    }
  }

  Future<Null> uploadImgAlbum(String email, File img) async {
    int x = Random().nextInt(1000000);
    final path = 'album/$email/$x';
    final file = File(img.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file).then((p0) => getAlbumUrl());
  }

  Future<Null> deleteImage() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (conttext) => SimpleDialog(
              children: [
                LoadingAnimationWidget.threeArchedCircle(
                    color: Contants.colorSpringGreen, size: 50)
              ],
            ));
    deleteImgAlbum().then((value) {
      int d = 0;
      while (d < filess!.length) {
        if (filess![d]["status"] == true) {
          filess!.removeAt(d);
        } else {
          d++;
        }
      }
      setState(() {
        stackClick = 0;
        filess;
      });
      print("ลบสำเร็จแล้ว");
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
