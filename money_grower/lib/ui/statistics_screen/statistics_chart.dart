import 'package:flutter/cupertino.dart';
import 'package:money_grower/helper/format_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:random_color/random_color.dart';

class DonutPieChart extends StatelessWidget {
  final List transactionList;

  DonutPieChart(this.transactionList);

  createSeriesList() {
    final formatter = FormatHelper();
    final data = transactionList
      .map((transaction) =>
      TransactionFigure(transaction.name, transaction.price))
      .toList();

    return [
      new charts.Series(
        id: 'Sales',
        domainFn: (TransactionFigure transaction, _) => transaction.name,
        measureFn: (TransactionFigure transaction, _) =>
          transaction.price.abs(),
        colorFn: (TransactionFigure transaction, _) =>
          charts.ColorUtil.fromDartColor(transaction.color),
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (TransactionFigure row, _) =>
        '${row.name}\n${formatter.formatMoney(row.price.abs(), 'đ')}',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (transactionList.isEmpty) {
      return Text('null');
    }
    return charts.PieChart(createSeriesList(),
      animate: false,
      defaultRenderer:
      charts.ArcRendererConfig(arcWidth: 80, arcRendererDecorators: [
        charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.auto)
      ]));
  }
}

class TransactionFigure {
  String name;
  int price;
  Color color;

  TransactionFigure(name, price) {
    final randomColor = RandomColor();
    this.name = name;
    this.price = price;

    if (price < 0) {
      this.color = randomColor.randomColor(
        colorHue: ColorHue.multiple(colorHues: [ColorHue.pink, ColorHue.red]),
        colorSaturation: ColorSaturation.mediumSaturation,
        colorBrightness: ColorBrightness.dark);
    } else {
      this.color = randomColor.randomColor(
        colorHue: ColorHue.green,
        colorSaturation: ColorSaturation.mediumSaturation,
        colorBrightness: ColorBrightness.dark);
    }
  }
}
