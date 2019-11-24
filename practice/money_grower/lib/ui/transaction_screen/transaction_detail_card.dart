import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/helper/icon_helper.dart';
import 'package:money_grower/models/transaction_model.dart';

// ignore: non_constant_identifier_names
Widget TransactionDetailCard(TransactionModel transaction) {
  return GestureDetector(
      onTap: () {
        print("Container clicked!");
      },
      child: Container(
          padding: EdgeInsets.fromLTRB(16, 15, 20, 10),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Icon(IconHelper().getIconByName(transaction.name),
                  color:
                      transaction.price < 0 ? Colors.redAccent : Colors.green,
                  size: 40),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(transaction.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 2),
                  Text(transaction.note)
                ],
              ),
              Spacer(),
              Text(FormatHelper().formatMoney(transaction.price.abs(), 'đ'),
                  style: TextStyle(
                      color: transaction.price < 0
                          ? Colors.redAccent
                          : Colors.green,
                      fontSize: 18))
            ],
          )));
}
