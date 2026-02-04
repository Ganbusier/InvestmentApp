import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'zh_CN',
    symbol: '¥ ',
    decimalDigits: 2,
  );

  static final NumberFormat percentFormat =
      NumberFormat.percentPattern('zh_CN');

  static String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }

  static String formatPercent(double value) {
    return percentFormat.format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日', 'zh_CN').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH:mm', 'zh_CN').format(dateTime);
  }
}
