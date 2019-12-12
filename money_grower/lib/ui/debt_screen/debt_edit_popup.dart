import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DebtEditPopup extends StatefulWidget {
  DebtTransactionModel transaction;

  DebtEditPopup(this.transaction);

  @override
  State<StatefulWidget> createState() => DebtEditPopupState();
}

class DebtEditPopupState extends State<DebtEditPopup> {
  deleteLoan(DebtTransactionModel transaction) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Xác nhận xoá giao dịch"),
              content: Text("\nGiao dịch này sẽ không được lưu",
                  style: TextStyle(fontSize: 16)),
              actions: [
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Xác nhận",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      transaction.done = true;
                      await TransactionBloc().updateTransaction(transaction);
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Huỷ bỏ"),
                    onPressed: () => Navigator.of(context).pop())
              ],
            ));
  }

  payLoan(DebtTransactionModel transaction) {
    if (transaction.price < 0) {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("Xác nhận thu tiền vay"),
                content: Text(
                    "\nGiao dịch thu tiền sẽ tự động thêm vào danh sách giao dịch",
                    style: TextStyle(fontSize: 16)),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("Xác nhận",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                      onPressed: () {
                        final now = DateTime.now();
                        final payTransaction = TransactionModel(
                            null,
                            'Thu nợ',
                            'Thu tiền vay',
                            transaction.price.abs(),
                            DateTime(now.year, now.month, now.day));
                        TransactionBloc().insertTransaction(payTransaction);
                        transaction.done = true;
                        TransactionBloc().updateTransaction(transaction);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("Huỷ bỏ"),
                      onPressed: () => Navigator.of(context).pop())
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text("Xác nhận trả nợ?"),
                content: Text(
                    "\nGiao dịch trả nợ sẽ tự động thêm vào danh sách giao dịch",
                    style: TextStyle(fontSize: 16)),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("Xác nhận",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent)),
                      onPressed: () async {
                        final now = DateTime.now();
                        final payTransaction = TransactionModel(
                            null,
                            'Trả nợ',
                            'Trả nợ',
                            -transaction.price,
                            DateTime(now.year, now.month, now.day));
                        await TransactionBloc().insertTransaction(payTransaction);
                        transaction.done = true;
                        await TransactionBloc().updateTransaction(transaction);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      }),
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("Huỷ bỏ"),
                      onPressed: () => Navigator.of(context).pop())
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    return Scaffold(
        appBar: AppBar(
          title: Text('Thông tin cho vay'),
          actions: <Widget>[
            Container(
                child: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteLoan(transaction))),
            Container(
                margin: EdgeInsets.only(right: 25),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => payLoan(transaction),
                ))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                child: Column(children: <Widget>[
                  TextFormField(
                    initialValue:
                        FormatHelper().formatMoney(transaction.price.abs()),
                    readOnly: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(15),
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      labelText: 'Số tiền',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    initialValue:
                        DateFormat("dd/MM/yyyy").format(transaction.date),
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: transaction.note,
                      labelText: 'Ngày cho vay',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    initialValue: 'Cho vay',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Loại giao dịch',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    initialValue: transaction.note.isEmpty
                        ? "Không có ghi chú"
                        : transaction.note,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: transaction.note,
                      labelText: 'Ghi chú',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 24),
                  ),
                ]))));
  }
}
