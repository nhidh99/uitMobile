import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_grower/blocs/budget_bloc.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/budget_model.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class BudgetEditPopup extends StatefulWidget {
  final budget;

  BudgetEditPopup(this.budget);

  @override
  State<StatefulWidget> createState() => BudgetEditPopupState();
}

class BudgetEditPopupState extends State<BudgetEditPopup> {
  final priceTextController = TextEditingController();
  final beginTextController = TextEditingController();
  final endTextController = TextEditingController();
  final nameTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final budget = widget.budget;

    priceTextController.text = FormatHelper().formatMoney(budget.totalBudget);
    nameTextController.text = budget.name;
    beginTextController.text =
        DateFormat("dd/MM/yyyy").format(budget.beginDate);
    endTextController.text = DateFormat("dd/MM/yyyy").format(budget.endDate);
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

  void submitBudget() async {
    final priceText = priceTextController.text.split(',').join('');
    final beginText = beginTextController.text;
    final endText = endTextController.text;
    final name = nameTextController.text;

    if (priceText.isEmpty ||
        priceText == '0' ||
        beginText.isEmpty ||
        endText.isEmpty ||
        name.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text("Lỗi"),
          content: Text(
              "\nSố tiền phải là số dương"
              "\nThông tin không được để trống",
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
      final totalBudget = int.parse(priceText);
      final beginDate = DateFormat("dd/MM/yyyy").parse(beginText);
      final endDate = DateFormat("dd/MM/yyyy").parse(endText);
      final totalUsed = await TransactionBloc().getPriceOfTransactionTypeInTime(
          name, beginDate, endDate, UserModel().username);

      if (endDate.compareTo(beginDate) < 0) {
        showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: Text("Lỗi"),
                  content: Text(
                      "\nNgày kết thúc không thể sớm hơn ngày bắt đầu",
                      style: TextStyle(fontSize: 16)),
                  actions: [
                    CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text("Đóng"),
                        onPressed: () => Navigator.of(context).pop())
                  ],
                ));
        return;
      }

      final budget = BudgetModel(
          widget.budget.id, name, beginDate, endDate, totalBudget, totalUsed);
      Navigator.of(context).pop();
      BudgetBloc().updateBudget(budget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm ngân sách'),
          actions: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 20),
                child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => submitBudget()))
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
                  ),
                  SizedBox(height: 30),
                  DateTimeField(
                    decoration: InputDecoration(
                      labelText: 'Ngày bắt đầu',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 22),
                    format: DateFormat("dd/MM/yyyy"),
                    controller: beginTextController,
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
                  DateTimeField(
                    decoration: InputDecoration(
                      labelText: 'Ngày kết thúc',
                      contentPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    style: TextStyle(fontSize: 22),
                    format: DateFormat("dd/MM/yyyy"),
                    controller: endTextController,
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
                ]))));
  }
}
