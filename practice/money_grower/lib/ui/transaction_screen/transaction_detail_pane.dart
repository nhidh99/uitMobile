import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/helper/format_helper.dart';
import 'package:loginapp/ui/transaction_screen/transaction_detail_card.dart';
import 'package:loginapp/ui/transaction_screen/transaction_summary.dart';
import 'package:sprintf/sprintf.dart';


// ignore: must_be_immutable
class TransactionDetailPane extends StatelessWidget {
  final dayOfWeek = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật'
  ];

  final monthOfYear = [
    'Một',
    'Hai',
    'Ba',
    'Tư',
    'Năm',
    'Sáu',
    'Bảy',
    'Tám',
    'Chín',
    'Mười',
    'Mười Một',
    'Mười Hai'
  ];

  DateTime date;

  TransactionDetailPane(this.date);

  @override
  Widget build(BuildContext context) {
    final transactionsOfDate = TransactionSummary()
        .transactionList
        .where((transaction) => transaction.date == date)
        .toList();

    final totalPrice = transactionsOfDate
        .map((transaction) => transaction.price)
        .reduce((a, b) => a + b);

    return Column(children: <Widget>[
      Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black26)),
              color: Colors.white),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: <Widget>[
              Text(sprintf("%02d", [date.day]),
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(dayOfWeek[date.weekday - 1],
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text(
                      sprintf("Tháng %s %d",
                          [monthOfYear[date.month - 1], date.year]),
                      style: TextStyle(color: Colors.black54))
                ],
              ),
              Spacer(),
              Text(FormatHelper().formatMoney(totalPrice.abs(), 'đ'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: totalPrice < 0 ? Colors.redAccent : Colors.green))
            ],
          )),
      ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactionsOfDate.length,
          itemBuilder: (BuildContext context, int index) {
            return TransactionDetailCard(transactionsOfDate[index]);
          }),
      SizedBox(height: 15)
    ]);
  }
}
