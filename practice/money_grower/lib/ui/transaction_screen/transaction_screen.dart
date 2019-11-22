import 'package:flutter/material.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/ui/transaction_screen/transaction_summary.dart';
import 'package:money_grower/ui/transaction_screen/transacton_summary_board.dart';
import 'package:month_picker_strip/month_picker_strip.dart';

class TransactionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {

  final summary = TransactionSummary();
  final transactionBloc = TransactionBloc();

  Future loadSummaryTransaction() async {
    final date = summary.date;
    final response =
        await transactionBloc.getTransactionSummaryOfMonth(date, 'nhidh99');
    return summary.fromMap(response);
  }

  // ignore: non_constant_identifier_names
  Widget MonthPicker(bool isDisable) {
    return AbsorbPointer(
        absorbing: isDisable,
        child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12)),
                color: Colors.white),
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: MonthStrip(
              format: 'MM/yyyy',
              from: new DateTime(1900, 4),
              to: new DateTime(2100, 5),
              initialMonth: summary.date,
              height: 48.0,
              viewportFraction: 0.33,
              onMonthChanged: (newMonth) {
                setState(() {
                  summary.date = newMonth;
                });
              },
              normalTextStyle: TextStyle(fontSize: 18, color: Colors.black26),
              selectedTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadSummaryTransaction(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text("Không có kết nối mạng"));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Column(
                children: <Widget>[
                  MonthPicker(true),
                  SizedBox(height: 40),
                  Center(child: CircularProgressIndicator())
                ],
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text("Lỗi kết nối"));
              else
                return Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size.fromHeight(205),
                        child: Column(children: <Widget>[
                          MonthPicker(false),
                          TransactionSummaryBoard()
                        ])),
                    body: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(children: <Widget>[
                          TransactionSummaryBoard(),
                          TransactionSummaryBoard(),
                          TransactionSummaryBoard()
                        ])),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {},
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat);
          }
          return null; // unreachable
        });
  }
}
