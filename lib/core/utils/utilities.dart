import 'package:intl/intl.dart';

class Utilities {
  static String formatMonth(String month) {
    if (month.isEmpty) return "";

    final parts = month.split("-");

    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]));

    return DateFormat("MMMM yyyy").format(date);
  }
}
