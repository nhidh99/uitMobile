import 'package:flutter/material.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/transaction_loan_card.dart';

class DebtScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DebtScreenState();
}

class DebtScreenState extends State<DebtScreen> {
  List loanList;
  List debtList;
  int totalLoanPrice;
  int totalDebtPrice;
  static int curTabIndex = 1;

  Future loadDebtAndLoanList() async {
    final loanDebtList = await TransactionBloc().getLoanDebtList(UserModel().username);
    totalLoanPrice = 0;
    totalDebtPrice = 0;
    loanList = loanDebtList['loan-list'];
    debtList = loanDebtList['debt-list'];
    loanList.forEach((loan) => totalLoanPrice += loan.price);
    debtList.forEach((debt) => totalDebtPrice += debt.price);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadDebtAndLoanList(),
        // a previously-obtained Future<String> or null
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text("Không có kết nối mạng"));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(child: CircularProgressIndicator())
                ],
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text("Lỗi kết nối"));
              else
                return DefaultTabController(
                    initialIndex: curTabIndex,
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
                                  indicatorPadding: EdgeInsets.only(
                                      bottom: 5, left: 35, right: 35),
                                  tabs: [
                                    Tab(
                                        icon: Text("CHO VAY",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16))),
                                    Tab(
                                        icon: Text("KHOẢN NỢ",
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16))),
                                  ],
                                ),
                              )),
                          preferredSize: Size.fromHeight(kToolbarHeight)),
                      body: Container(
                        color: Colors.white,
                        child: TabBarView(
                          children: [
                            Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Center(
                                    child: Text(
                                        "DANH SÁCH VAY | " +
                                            FormatHelper().formatMoney(
                                                -totalLoanPrice, 'đ'),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green))),
                              ),
                              Divider(color: Colors.black38),
                              LoanBoard(loanList)
                            ]),
                            Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                child: Center(
                                  child: Text(
                                    "DANH SÁCH NỢ | " +
                                      FormatHelper().formatMoney(
                                        totalDebtPrice, 'đ'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent))),
                              ),
                              Divider(color: Colors.black38),
                              DebtBoard(debtList)
                            ])
                          ],
                        ),
                      ),
                    ));
          }
        });
  }
}

class DebtBoard extends StatelessWidget {
  final debtList;

  DebtBoard(this.debtList);

  @override
  Widget build(BuildContext context) {
    DebtScreenState.curTabIndex = 1;
    if (debtList.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        color: Colors.white,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(":-)",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45))),
            SizedBox(height: 15),
            Center(
              child: Text("Không có khoản vay",
                style: TextStyle(fontSize: 24, color: Colors.black45)))
          ],
        ));
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: debtList.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(children: <Widget>[
          TransactionLoanCard(debtList[index], true),
          Divider(color: Colors.black38),
        ]);
      });
  }
}

class LoanBoard extends StatelessWidget {
  final loanList;

  LoanBoard(this.loanList);

  @override
  Widget build(BuildContext context) {
    DebtScreenState.curTabIndex = 0;
    if (loanList.isEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        color: Colors.white,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(":-)",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45))),
            SizedBox(height: 15),
            Center(
              child: Text("Không có khoản vay",
                style: TextStyle(fontSize: 24, color: Colors.black45)))
          ],
        ));
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: loanList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            TransactionLoanCard(loanList[index], true),
            Divider(color: Colors.black38),
          ]);
        });
  }
}
