import 'package:intl/intl.dart';

class FormatHelper {
  String unit = "đ";

  formatMoney(int value) {
      final formatter = NumberFormat("#,###");
      return formatter.format(value) + unit;
  }
}