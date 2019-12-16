import 'package:intl/intl.dart';

class FormatHelper {
  formatMoney(value, [String unit]) {
    if (value == null) {
      return "";
    }
    var formatter;
    if (value is int) {
      formatter = NumberFormat("#,###");
    }
    else {
      formatter = NumberFormat("#,###.###");
    }

    var output = formatter.format(value);
    if (unit != null) output += unit;
    return output;
  }
}
