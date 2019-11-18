import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {},
          )),
    );
  }
}
