import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:money_grower/blocs/budget_bloc.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/budget_model.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/faded_transition.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


import 'budget_category_page.dart';
import 'budget_screen.dart';

class BudgetAddPopup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BudgetAddPopupState();
}

class BudgetAddPopupState extends State<BudgetAddPopup> {
  final priceTextController = TextEditingController();
  final beginTextController = TextEditingController();
  final endTextController = TextEditingController();
  final nameTextController = TextEditingController();
  bool _saving = false;

  void saveSubmit() {
    setState(() {
      _saving = true;
    });
    Future.delayed(new Duration(seconds: 4), () {
      setState(() {
        _saving = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    priceTextController.text = '0';
    beginTextController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    endTextController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
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
      if (BudgetScreenState.budgetList.map((b) => b.name).contains(name)) {
        showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: Text("Ngân sách đã tồn tại"),
                  content: Text(
                      "\nNgân sách " + name + " đã tồn tại trong danh sách",
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

      saveSubmit();
      final budget =
          BudgetModel(null, name, beginDate, endDate, totalBudget, totalUsed);
      BudgetBloc().insertBudget(budget);
      Navigator.of(context).pop();
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
                    icon: Icon(Icons.playlist_add_check),
                    onPressed: () => submitBudget()))
          ],
        ),
        body: ModalProgressHUD(child: SingleChildScrollView(
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
                      onTap: () => Navigator.push(context,
                          FadeRoute(page: BudgetCategoryPage(setName)))),
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
                ]))), inAsyncCall: _saving));
  }
}
