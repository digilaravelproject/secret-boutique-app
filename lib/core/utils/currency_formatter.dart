import 'package:intl/intl.dart';

/// Formats numerical amounts into Indian Rupee strings, e.g. ₹499
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num amount) {
    return _formatter.format(amount);
  }
}
