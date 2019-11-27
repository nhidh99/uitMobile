import 'package:flutter/material.dart';
import 'package:money_grower/blocs/transaction_bloc.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/transaction_loan_card.dart';

class DebtScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DebtScreenState();
}

class DebtScreenState extends State<DebtScreen>
    with AutomaticKeepAliveClientMixin {
  List loanList;
  int totalLoanPrice;

  Future loadDebtAndLoanList() async {
    totalLoanPrice = 0;
    loanList = await TransactionBloc().getLoanList(UserModel().username);
    loanList.forEach((loan) => totalLoanPrice += loan.price);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    initialIndex: 1,
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
                                        "DANH SÁCH CHO VAY | " +
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
                            SingleChildScrollView(
                                child: Column(children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                color: Colors.white,
                                child: Center(
                                    child: Text("DANH SÁCH KHOẢN NỢ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.redAccent))),
                              ),
                            ]))
                          ],
                        ),
                      ),
                    ));
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class LoanBoard extends StatelessWidget {
  final loanList;

  LoanBoard(this.loanList);

  @override
  Widget build(BuildContext context) {
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
