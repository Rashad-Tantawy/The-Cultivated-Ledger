import 'package:intl/intl.dart';

class DateFormatter {
  static final _short = DateFormat('MMM d, yyyy');
  static final _long = DateFormat('MMMM d, yyyy');
  static final _monthYear = DateFormat('MMM yyyy');
  static final _relative = DateFormat('MMM d');

  static String short(DateTime date) => _short.format(date);
  static String long(DateTime date) => _long.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return _relative.format(date);
  }

  static String maturity(int months) {
    if (months < 12) return '$months months';
    final years = months ~/ 12;
    final rem = months % 12;
    if (rem == 0) return '$years yr${years > 1 ? 's' : ''}';
    return '$years yr $rem mo';
  }
}
