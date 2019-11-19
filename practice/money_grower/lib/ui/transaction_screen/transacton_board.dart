import 'package:flutter/material.dart';

class TransactionSummaryBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Summary of total incoming
    return Column(children: <Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Icon(Icons.attach_money, color: Colors.green),
              SizedBox(width: 8),
              Text("Tiền vào:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              Spacer(),
              Text("300,000đ",
                  style: TextStyle(fontSize: 18, color: Colors.green)),
            ],
          )),

      // Summary of total outgoings
      Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Icon(Icons.money_off, color: Colors.redAccent),
              SizedBox(width: 8),
              Text("Tiền ra:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent)),
              Spacer(),
              Text("0đ",
                  style: TextStyle(fontSize: 18, color: Colors.redAccent))
            ],
          )),

      // Summary of total transaction value
      Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Icon(Icons.monetization_on, color: Colors.blue),
              SizedBox(width: 8),
              Text("Tổng cộng:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              Spacer(),
              Text("300,000đ",
                  style: TextStyle(fontSize: 18, color: Colors.blue))
            ],
          ))
    ]);
  }
}

class TransactionBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        TransactionSummaryBoard(),
      ],
    ));
  }
}
