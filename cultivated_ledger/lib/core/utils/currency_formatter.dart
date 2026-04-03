import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _usd = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  static final _compact = NumberFormat.compactCurrency(locale: 'en_US', symbol: '\$');
  static final _percent = NumberFormat.decimalPercentPattern(locale: 'en_US', decimalDigits: 1);

  static String format(double amount) => _usd.format(amount);

  static String compact(double amount) => _compact.format(amount);

  static String percent(double value) => _percent.format(value / 100);

  static String formatRoi(double roiPercent) => '+${roiPercent.toStringAsFixed(1)}%';
}
