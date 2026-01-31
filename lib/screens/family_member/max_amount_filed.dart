import 'package:flutter/services.dart';

class MaxAmountInputFormatter extends TextInputFormatter {
  final double max;

  MaxAmountInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    double? value = double.tryParse(newValue.text);
    if (value == null) return oldValue; // invalid input, keep old

    if (value > max) {
      // prevent typing more than max
      return oldValue;
    }

    return newValue;
  }
}
