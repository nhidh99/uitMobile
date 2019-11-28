import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/ui/debt_screen/debt_edit_popup.dart';
import 'package:sprintf/sprintf.dart';

// ignore: non_constant_identifier_names, must_be_immutable
class TransactionLoanCard extends StatelessWidget {
  TransactionModel transaction;
  bool isBoldPrice;

  TransactionLoanCard(this.transaction, this.isBoldPrice);

  @override
  Widget build(BuildContext context) {
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

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DebtEditPopup(transaction),
                fullscreenDialog: true)),
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: <Widget>[
                Text(sprintf("%02d", [transaction.date.day]),
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(dayOfWeek[transaction.date.weekday - 1],
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text(
                        sprintf("Tháng %s %d", [
                          monthOfYear[transaction.date.month - 1],
                          transaction.date.year,
                        ]),
                        style: TextStyle(
                            color: Colors.black54)),
                    SizedBox(height: 2),
                    transaction.note.isEmpty
                        ? SizedBox.shrink()
                        : Text(transaction.note,
                            style: TextStyle(color: Colors.black54))
                  ],
                ),
                Spacer(),
                Text(FormatHelper().formatMoney(transaction.price.abs(), 'đ'),
                    style: TextStyle(
                        fontWeight:
                            isBoldPrice ? FontWeight.bold : FontWeight.normal,
                        fontSize: 18,
                        color: transaction.price < 0
                            ? Colors.green
                            : Colors.redAccent))
              ],
            )));
  }
}
