import 'package:intl/intl.dart';

String formatCurrency(double value, {String currency = 'BRL'}) {
  switch (currency.toUpperCase()) {
    case 'USD':
      return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(value);
    case 'BRL':
    default:
      return NumberFormat.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
      ).format(value);
  }
}
