import 'package:flutter/material.dart';
import 'package:money_grower/blocs/budget_bloc.dart';
import 'package:money_grower/models/user_model.dart';
import 'package:money_grower/ui/custom_control/budget_card.dart';

import 'budget_add_popup.dart';

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
              return Column(
                children: <Widget>[Center(child: CircularProgressIndicator())],
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text("Lỗi kết nối"));
              else
                return Scaffold(
                    body: ListView.builder(
                        shrinkWrap: true,
                        itemCount: budgetList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(children: <Widget>[
                            BudgetCard(budgetList[index], reloadBudgets),
                            Divider(color: Colors.black38),
                          ]);
                        }),
                    floatingActionButton: FloatingActionButton(
                      heroTag: 'btn-budget',
                      child: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BudgetAddPopup(),
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
