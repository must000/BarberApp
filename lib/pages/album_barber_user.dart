import 'package:flutter/material.dart';

class AlbumBarberUser extends StatefulWidget {
  const AlbumBarberUser({Key? key}) : super(key: key);

  @override
  State<AlbumBarberUser> createState() => _AlbumBarberUserState();
}

class _AlbumBarberUserState extends State<AlbumBarberUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.amber,
          child: Center(child: Text('$index')),
        );
      },
      itemCount: 50,
    ),
    );
  }
}
