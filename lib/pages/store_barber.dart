import 'dart:io';
import 'dart:typed_data';

import 'package:barber/main.dart';
import 'package:barber/utils/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreBarber extends StatefulWidget {
  String email;
  StoreBarber({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<StoreBarber> createState() => _StoreBarberState(email: this.email);
}

class _StoreBarberState extends State<StoreBarber> {
  String? email;
  _StoreBarberState({required this.email});
  TextEditingController recommendController = TextEditingController();
  bool change = false;
  String? iii;
  CollectionReference users = FirebaseFirestore.instance.collection('Barber');
  String? imgurl;
  File? photoShopFront;
  List<Map<String, dynamic>>? filess;
  int deleteAlbum = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findRecommend();
    getURL();
    getAlbumUrl();
  }

  Future<Null> findRecommend() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        setState(() {
          email = event!.email;
        });
        final data =
            FirebaseFirestore.instance.collection('Barber').doc(event!.email);
        final snapshot = await data.get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          recommendController.text = data['shoprecommend'];
          iii = data['shoprecommend'];
        }
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchImages(String uniqueUserId) async {
    List<Map<String, dynamic>> files = [];
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('album')
        .child(uniqueUserId)
        .list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();

      files.add({
        'url': fileUrl,
        'path': file.fullPath,
        'uploaded_by': fileMeta.customMetadata!['uploaded_by'] ?? 'Nobody',
        'description':
            fileMeta.customMetadata!['description'] ?? 'No description'
      });
      print('result is $files');
    });
    return files;
  }

  Future<Null> getAlbumUrl() async {
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('album')
        .child(email!)
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
      print(files);
    });
    setState(() {
      filess = files;
    });
  }

  Future<Null> getURL() async {
    Reference ref = FirebaseStorage.instance.ref().child("imgfront/$email");
    var url = await ref.getDownloadURL().then((value) {
      setState(() {
        imgurl = value;
        photoShopFront = null;
      });
    }).catchError((c) => print(c + "is an error"));
  }

  Future<Null> deleteImg() async {
    final storageRef = FirebaseStorage.instance.ref();
    final desertRef = storageRef.child("imgfront/$email");
    await desertRef.delete().then((value) => debugPrint("delete succeed"));
  }

  Future<Null> normalDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.camera);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.camera_alt),
              ),
              ElevatedButton(
                onPressed: () {
                  chooseImage(ImageSource.gallery);
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

  Future<Null> chooseImage(ImageSource source) async {
    try {
      // ignore: deprecated_member_use
      var result = await ImagePicker().getImage(
        source: source,
      );
      setState(() {
        photoShopFront = File(result!.path);
      });
    } catch (e) {}
  }

  Future<Null> uploadphoto(String email) async {
    final path = 'imgfront/$email';
    final file = File(photoShopFront!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file).then((p0) => getURL());
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            showRecommend(),
            change == true ? buttonsRecommend(context) : const SizedBox(),
            const SizedBox(
              height: 40,
            ),
            const Text("รูปหน้าร้าน"),
            showimageFront(size),
            buttonChangeImgFront(context),
            photoShopFront == null
                ? const SizedBox()
                : buttonDeleteAndUpdateImgFront(),
            const SizedBox(
              height: 10,
            ),
            buttonDeleteimgAlbum(),
            filess == null
                ? const SizedBox(
                    child: Text('ไม่มีรูปในอัลบั้ม'),
                  )
                : showImgAlbum()
          ],
        ),
      ),
    );
  }

  Expanded showImgAlbum() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                if (filess![index]['status'] == false) {
                  deleteAlbum++;
                } else {
                  deleteAlbum--;
                }
                filess![index]['status'] = !filess![index]['status'];
              });
            },
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: filess![index]['status'] == true
                      ? Colors.red
                      : const Color.fromARGB(255, 172, 172, 172)),
              child: Card(
                child: Image.network(filess![index]['url'].toString()),
              ),
            ),
          );
        },
        itemCount: filess!.length,
      ),
    );
  }

  Row buttonDeleteimgAlbum() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "",
            style: TextStyle(fontSize: 20),
          ),
        ),
        IconButton(
            onPressed: () {
              if (deleteAlbum > 0) {
                deleteImgAlbum();
              }
            },
            icon: Icon(
              Icons.delete_forever,
              size: 40,
              color: deleteAlbum > 0 ? Colors.red : Colors.black,
            ))
      ],
    );
  }

  Future<Null> deleteImgAlbum() async {
    for (var i = 0; i < filess!.length; i++) {
      if (filess![i]["status"] == true) {
        //ถ้าเจอtrue ให้ลบ
        final storageRef = FirebaseStorage.instance.ref();
        final desertRef = storageRef.child(filess![i]["path"]);
        await desertRef
            .delete()
            .then((value) {
              debugPrint("delete ${filess![i]["path"]}");
            });
            // test ลบสำเร็จ เหลือรีเฟรชข้อมูล
      }
    }
  }

  Row buttonDeleteAndUpdateImgFront() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: () {
            setState(() {
              photoShopFront = null;
            });
          },
          child: const Text("ลบรูปภาพ"),
        ),
        ElevatedButton(
            onPressed: () {
              deleteImg().then((value) => uploadphoto(email!));
            },
            child: const Text("อัพเดตรูปภาพ"))
      ],
    );
  }

  ElevatedButton buttonChangeImgFront(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          normalDialog(context);
        },
        child: const Text("เปลี่ยนรูปภาพ"));
  }

  Container showimageFront(double size) {
    return Container(
      width: size * 0.7,
      margin: const EdgeInsets.only(top: 10),
      height: 180,
      decoration: BoxDecoration(border: Border.all()),
      child: photoShopFront != null
          ? Image.file(photoShopFront!)
          : imgurl == null
              ? SizedBox(
                  child: const CircularProgressIndicator(),
                  width: size * 0.3,
                )
              : CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imgurl!,
                  placeholder: (context, url) => SizedBox(
                    child: const CircularProgressIndicator(),
                    width: size * 0.3,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
    );
  }

  Row buttonsRecommend(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                recommendController.text = iii!;
                change = false;
                FocusScope.of(context).requestFocus(FocusNode());
              });
            },
            child: const Text("รีเซ็ต")),
        ElevatedButton(
            onPressed: () {
              CollectionReference users =
                  FirebaseFirestore.instance.collection('Barber');
              users.doc(email).update(
                  {"shoprecommend": recommendController.text}).then((value) {
                print("update succeed");
                iii = recommendController.text;
                FocusScope.of(context).requestFocus(FocusNode());
              }).catchError((x) => MyDialog().normalDialog(context, x));
            },
            child: const Text("บันทึก")),
      ],
    );
  }

  TextFormField showRecommend() {
    return TextFormField(
      controller: recommendController,
      maxLines: 4,
      onChanged: (value) {
        setState(() {
          change = true;
        });
      },
      decoration: InputDecoration(
        labelText: "คำแนะนำร้าน",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
