import 'package:flutter/material.dart';
import 'package:money_grower/blocs/budget_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/budget_card.dart';
import 'package:money_grower/ui/custom_control/faded_transition.dart';

import 'budget_add_popup.dart';
import 'package:progress_indicators/progress_indicators.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BudgetScreenState();
}

class BudgetScreenState extends State<BudgetScreen> {
  static List budgetList;

  Function reloadBudgets;

  Future loadBudgets() async {
    budgetList = await BudgetBloc().getBudgetsByUsername(UserModel().username);
  }

  void _reloadBudgets() => setState(() {});

  @override
  void initState() {
    super.initState();
    reloadBudgets = _reloadBudgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadBudgets(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text("Không có kết nối mạng"));
            case ConnectionState.active:
            case ConnectionState.waiting:
              return JumpingDotsProgressIndicator(
                  fontSize: 30, color: Colors.green);
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text("Lỗi kết nối"));
              else
                return Scaffold(
                    body: BudgetBoard(budgetList, reloadBudgets),
                    floatingActionButton: FloatingActionButton(
                      heroTag: 'btn-budget',
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context, FadeRoute(page: BudgetAddPopup()));
                      },
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat);
          }
          return null; // unreachable
        });
  }
}

class BudgetBoard extends StatelessWidget {
  final budgetList;
  final reloadBudgets;

  BudgetBoard(this.budgetList, this.reloadBudgets);

  @override
  Widget build(BuildContext context) {
    if (budgetList.isEmpty) {
      return Container(
          padding: EdgeInsets.only(top: 50),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                  child: Text(":-(",
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45))),
              SizedBox(height: 15),
              Center(
                  child: Text("Không có ngân sách",
                      style: TextStyle(fontSize: 24, color: Colors.black45))),
              SizedBox(height: 15),
              Center(
                  child: Text("Nhấn + để thêm ngân sách",
                      style: TextStyle(fontSize: 16, color: Colors.black45)))
            ],
          ));
    } else
      return ListView.builder(
          shrinkWrap: true,
          itemCount: budgetList.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: <Widget>[
              BudgetCard(budgetList[index], reloadBudgets),
              Divider(color: Colors.black38),
            ]);
          });
  }
}
