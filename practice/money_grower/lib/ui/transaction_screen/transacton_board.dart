import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_grower/models/user_model.dart';

class TransactionSummaryBoard extends StatefulWidget {
  String income;
  String outgoings;
  String total;

  TransactionSummaryBoard() {
    final user = UserModel();
    final formatter = NumberFormat("#,###");
    this.income = formatter.format(user.income) + "đ";
    this.outgoings = formatter.format(user.outgoings) + "đ";
    this.total = formatter.format(user.income - user.outgoings) + "đ";
  }

  @override
  State<StatefulWidget> createState() => TransactionSummaryState();
}

class TransactionSummaryState extends State<TransactionSummaryBoard> {

  // Thêm lượng thu vào tiền thu
  addIncoming(int value) {
    final formatter = NumberFormat("#,###");
    final newIncoming = formatter.parse(widget.income) + value;
    final newTotal = formatter.parse(widget.total) + value;
    setState(() {
      widget.income = formatter.format(newIncoming);
      widget.outgoings = formatter.format(newTotal);
    });
  }

  // Thêm lượng chi vào tiền chi
  addOutgoings(int value) {
    final formatter = NumberFormat("#,###");
    final newIncoming = formatter.parse(widget.income) + value;
    final newTotal = formatter.parse(widget.total) - value;
    setState(() {
      widget.income = formatter.format(newIncoming);
      widget.outgoings = formatter.format(newTotal);
    });
  }

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
            Text(widget.income,
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
            Text(widget.outgoings,
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
            Text(widget.total,
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
