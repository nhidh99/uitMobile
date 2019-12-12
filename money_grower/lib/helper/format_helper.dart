import 'package:intl/intl.dart';

class FormatHelper {
  formatMoney(int value, [String unit]) {
    if (value == null) {
      return "";
    }
    final formatter = NumberFormat("#,###");
    var output = formatter.format(value);
    if (unit != null) output += unit;
    return output;
  }
}
