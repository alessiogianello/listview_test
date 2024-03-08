import 'package:flutter/material.dart';

class Details_page extends StatelessWidget {
  final int number;
  Details_page({required this.number});
  @override
  Widget build(BuildContext context) {
    final square = number * number;
    return Scaffold(
      appBar: AppBar(title: Text("Dettaglio")),
      body: Center(
          child: Column(
        children: [
          Text(number.toString()),
          SizedBox(height: 20),
          Text(square.toString())
        ],
      )),
    );
  }
}
