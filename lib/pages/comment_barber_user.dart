import 'package:flutter/material.dart';

class CommentBarberUser extends StatefulWidget {
  const CommentBarberUser({Key? key}) : super(key: key);

  @override
  State<CommentBarberUser> createState() => _CommentBarberUserState();
}

class _CommentBarberUserState extends State<CommentBarberUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("คะแนนและความคิดเห็น"),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: const Text("ชื่อUser"),
            subtitle: const Text(
                "ความคิดเห็นนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนนน"),
            trailing: Wrap(children: const [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
