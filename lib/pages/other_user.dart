import 'package:barber/provider/myproviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherUser extends StatefulWidget {
  const OtherUser({Key? key}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        logout(context)
        
      ],),
    );
  }
   logout(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final provider = Provider.of<MyProviders>(context, listen: false);
          provider.logout();
        },
        child: const Text("logout"));
  }
}
