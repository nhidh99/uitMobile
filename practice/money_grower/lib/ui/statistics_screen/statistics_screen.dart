import 'package:flutter/material.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/models/transaction_model.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/month_striper.dart';
import 'package:money_grower/ui/statistics_screen/statistics_chart.dart';
import 'package:money_grower/ui/statistics_screen/statistics_board.dart';
import 'package:money_grower/ui/transaction_screen/transaction_summary.dart';
import 'package:money_grower/ui/transaction_screen/transacton_summary_board.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  final transactionBloc = TransactionBloc();
  final username = UserModel().username;
  final summary = TransactionSummary();
  var incomeList;
  var expenseList;

  Future loadSummaryTransaction() async {
    final date = summary.date;
    final response =
        await transactionBloc.getTransactionSummaryOfMonth(date, username);
    summary.fromMap(response);

    final incomes = summary.transactionList
        .where((t) => t.price > 0)
        .map((t) => t.name)
        .toSet();

    final expenses = summary.transactionList
        .where((t) => t.price < 0)
        .map((t) => t.name)
        .toSet();

    incomeList = incomes
        .map((income) => TransactionModel(
            null,
            income,
            '',
            summary.transactionList
                .where((t) => t.name == income)
                .map((t) => t.price)
                .reduce((a, b) => a + b),
            null))
        .toList();

    expenseList = expenses
        .map((expense) => TransactionModel(
            null,
            expense,
            '',
            summary.transactionList
                .where((t) => t.name == expense)
                .map((t) => t.price)
                .reduce((a, b) => a + b),
            null))
        .toList();

    return summary;
  }

  void reloadSummary(DateTime date) {
    setState(() {
      summary.date = date;
    });
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
                  MonthStriper(summary.date, true),
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
                        preferredSize: Size.fromHeight(200),
                        child: Column(children: <Widget>[
                          MonthStriper(summary.date, false, reloadSummary),
                          TransactionSummaryBoard()
                        ])),
                    body: DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: Scaffold(
                        appBar: PreferredSize(
                            child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0, 0),
                                    blurRadius: 0.0,
                                  )
                                ]),
                                child: AppBar(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  title: TabBar(
                                    indicatorColor: Colors.black26,
                                    indicatorPadding:
                                        EdgeInsets.only(bottom: 5, left: 35, right: 35),
                                    tabs: [
                                      Tab(
                                          icon: Text("KHOẢN THU",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16))),
                                      Tab(
                                          icon: Text("KHOẢN CHI",
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 16))),
                                    ],
                                  ),
                                )),
                            preferredSize: Size.fromHeight(kToolbarHeight)),
                        body: TabBarView(
                          children: [
                            SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                color: Colors.white,
                                child: Center(
                                    child: Text("THỐNG KÊ KHOẢN THU",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green))),
                              ),
                              StatisticsBoard(incomeList)
                            ])),
                            SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                color: Colors.white,
                                child: Center(
                                    child: Text("THỐNG KÊ KHOẢN CHI",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red))),
                              ),
                              StatisticsBoard(expenseList)
                            ]))
                          ],
                        ),
                      ),
                    ));
          }
          return null; // unreachable
        });
  }
}
