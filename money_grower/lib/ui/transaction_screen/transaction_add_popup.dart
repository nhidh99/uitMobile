import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/ui/custom_control/faded_transition.dart';
import 'package:money_grower/ui/transaction_screen/transaction_category_page.dart';

class TransactionAddPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionAddPopupState();
}

class TransactionAddPopupState extends State<TransactionAddPopup> {
  final priceTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final noteTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priceTextController.text = '0';
    dateTextController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
  }

  void setPrice(String price) {
    final parseText = price.split(',').join('');
    final formattedText = FormatHelper().formatMoney(int.parse(parseText));
    priceTextController.value = TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  void setName(String name) {
    nameTextController.text = name;
  }

  void submitTransaction() async {
    final priceText = priceTextController.text.split(',').join('');
    final dateText = dateTextController.text;
    final name = nameTextController.text;
    final note = noteTextController.text.trim();

    if (priceText.isEmpty ||
      priceText == '0' ||
      dateText.isEmpty ||
      name.isEmpty) {
      showDialog(
        context: context,
        builder: (_) =>
          CupertinoAlertDialog(
            title: Text("Lỗi"),
            content: Text(
              "Số tiền phải là số dương\n"
                "Ngày giao dịch và loại giao dịch không được để trống.",
              style: TextStyle(fontSize: 16)),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Đóng"),
                onPressed: () => Navigator.of(context).pop())
            ],
          ),
      );
    } else {
      final isIncomeTransaction = [
        "Thưởng",
        "Lương",
        "Tiền lãi",
        "Bán đồ",
        "Được tặng",
        "Vay tiền",
        "Thu nợ"
      ].contains(name);

      final price = int.parse(priceText);
      final date = DateFormat("dd/MM/yyyy").parse(dateText);
      var transaction;

      if (name == 'Cho vay' || name == 'Vay tiền') {
        transaction = DebtTransactionModel(
          null, name, note, isIncomeTransaction ? price : -price, date);
      }
      else {
        transaction = TransactionModel(
          null, name, note, isIncomeTransaction ? price : -price, date);
      }

      await TransactionBloc().insertTransaction(transaction);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm giao dịch'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(Icons.playlist_add_check),
              onPressed: () => submitTransaction()))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 40),
          child: Column(children: <Widget>[
            TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(15),
                WhitelistingTextInputFormatter.digitsOnly
              ],
              controller: priceTextController,
              onChanged: (text) => setPrice(text),
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
            DateTimeField(
              decoration: InputDecoration(
                labelText: 'Thời gian',
                contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              ),
              style: TextStyle(fontSize: 22),
              format: DateFormat("dd/MM/yyyy"),
              controller: dateTextController,
              readOnly: true,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
                if (date != null) {
                  return DateTimeField.combine(date, null);
                } else {
                  return currentValue;
                }
              },
            ),
            SizedBox(height: 30),
            TextField(
              controller: nameTextController,
              decoration: InputDecoration(
                labelText: 'Loại giao dịch',
                contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              ),
              style: TextStyle(fontSize: 24),
              readOnly: true,
              onTap: () =>
                Navigator.push(
                  context,
                  FadeRoute(page:TransactionCategoryPage(setName)))
            ),
            SizedBox(height: 30),
            TextField(
              controller: noteTextController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              decoration: InputDecoration(
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
