import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginapp/Pages/transaction_category.dart';


class AddTransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<AddTransactionPage> {
  final format = DateFormat("dd-MM-yyyy");
  final List<String> category = ['Ăn uống', 'Đi lại','Giải trí','Di chuyển','Sức khỏe'];
  String selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: () {})
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.attach_money),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Số tiền',
              ),
              keyboardType: TextInputType.number  ,
            ),
          ),
          ListTile(
            leading: Icon(Icons.event_note),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Ghi chú',
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: new  DateTimeField(
              format: format,
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
          ),
          ListTile(
              leading: Icon(Icons.category),
              title: new DropdownButton(
                  hint: Text("Chọn 1 loại giao dịch"),
                  value: selectedCategory,
                  items: category.map((_category) {
                    return DropdownMenuItem(
                      child: new Text(_category),
                      value: _category,
                    );
                  }).toList(),
                  onChanged: (newValue){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionCategoryPage(), fullscreenDialog: true));
                  }
              )
          ),
        ],
      ),
    );
  }
}
