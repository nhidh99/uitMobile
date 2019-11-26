import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_grower/ui/cards/transaction_date_card.dart';
import 'package:money_grower/ui/cards/transaction_detail_card.dart';
import 'package:money_grower/ui/statistics_screen/statistics_chart.dart';
import 'package:money_grower/ui/transaction_screen/transaction_summary.dart';

class StatisticsBoard extends StatelessWidget {
  List list;
  List datesOfList = [];

  StatisticsBoard(List list) {
    this.list = list;
    list.forEach((income) {
      final transactions = TransactionSummary()
          .transactionList
          .where((t) => t.name == income.name).toList();
      final diffDates = transactions.map((t) => t.date).toSet();
      final transactionDateList = diffDates.map((date) => TransactionDate(
          date,
          transactions
              .where((t) => t.date == date)
              .map((t) => t.price)
              .reduce((a, b) => a + b))).toList();
      datesOfList.add(transactionDateList);
    });
  }

  //  TransactionModel(this.id, this.name, this.note, this.price, this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            child: SizedBox(height: 260, child: DonutPieChart(list))),
        AbsorbPointer(
            absorbing: true,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index0) {
                return Column(children: <Widget>[
                  TransactionDetailCard(list[index0], true),
                  Container(
                      color: Colors.white,
                      child: Divider(
                        color: Colors.black87,
                      )),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: datesOfList[index0].length,
                      itemBuilder: (BuildContext context, int index1) {
                        return TransactionDateCard(
                            datesOfList[index0][index1].date,
                            datesOfList[index0][index1].price,
                            false);
                      }),
                  Container(color: Colors.white, height: 10),
                  SizedBox(height: 20),
                ]);
              },
            ))
      ],
    );
  }
}

class TransactionDate {
  final date;
  final price;
  TransactionDate(this.date, this.price);
}
