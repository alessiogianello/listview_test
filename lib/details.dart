import 'package:flutter/material.dart';
import 'package:listview_test/users.dart';

class Details_page extends StatelessWidget {
  final User user;
  Details_page({required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dettaglio")),
      body: Center(
          child: Column(
        children: [
          Text(user.id.toString()),
          SizedBox(height: 20),
          Text(user.name)
        ],
      )),
    );
  }
}
