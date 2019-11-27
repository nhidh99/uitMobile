import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/helper/icon_helper.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/ui/transaction_screen/transaction_edit_popup.dart';

// ignore: non_constant_identifier_names, must_be_immutable
class TransactionDetailCard extends StatelessWidget {
  TransactionModel transaction;
  bool isBoldPrice = true;

  TransactionDetailCard(this.transaction, [this.isBoldPrice]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TransactionEditPopup(transaction),
                  fullscreenDialog: true));
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
                    transaction.note.isNotEmpty
                        ? Text(transaction.note)
                        : SizedBox.shrink()
                  ],
                ),
                Spacer(),
                Text(FormatHelper().formatMoney(transaction.price.abs(), 'đ'),
                    style: TextStyle(
                        color: transaction.price < 0
                            ? Colors.redAccent
                            : Colors.green,
                        fontSize: 18,
                        fontWeight:
                            isBoldPrice ? FontWeight.bold : FontWeight.normal))
              ],
            )));
  }
}
