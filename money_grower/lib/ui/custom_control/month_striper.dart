import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'month_strip.dart';

// ignore: non_constant_identifier_names, must_be_immutable
class MonthStriper extends StatelessWidget {
  DateTime date;
  bool isDisable;
  Function callback;

  MonthStriper(this.date, this.isDisable, [this.callback]);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisable,
      child: Container(
        decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 1.0, color: Colors.black26)),
          color: Colors.white),
        child: MonthStrip(
          format: 'MM/yyyy',
          from: new DateTime(1900, 4),
          to: new DateTime(2100, 5),
          initialMonth: date,
          viewportFraction: 0.33,
          onMonthChanged: (newMonth) {
            if (callback != null) {
              callback(newMonth);
            }
          },
          normalTextStyle: TextStyle(fontSize: 18, color: Colors.black26),
          selectedTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        )));
  }
}
