import 'package:flutter/material.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/transaction_screen/transaction_add_popup.dart';
import 'package:money_grower/ui/transaction_screen/transaction_detail_board.dart';
import 'package:money_grower/ui/transaction_screen/transaction_summary.dart';
import 'package:money_grower/ui/transaction_screen/transacton_summary_board.dart';
import 'package:money_grower/ui/custom_control/month_striper.dart';

class TransactionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  final summary = TransactionSummary();
  final transactionBloc = TransactionBloc();
  final username = UserModel().username;

  Future loadSummaryTransaction() async {
    final date = summary.date;
    final response =
        await transactionBloc.getTransactionSummaryOfMonth(date, username);
    return summary.fromMap(response);
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
                    body: TransactionDetailBoard(),
                    floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionAddPopup(),
                                fullscreenDialog: true));
                      },
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat);
          }
          return null; // unreachable
        });
  }
}