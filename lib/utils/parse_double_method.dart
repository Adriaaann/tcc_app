double parseDouble(String text) {
  String numericString = text.replaceAll(RegExp(r'[^0-9,\.]'), '');

  if (numericString.contains(',')) {
    numericString = numericString.replaceAll('.', '').replaceAll(',', '.');
  }

  return double.tryParse(numericString) ?? 0.0;
}
