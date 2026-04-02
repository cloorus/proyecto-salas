import 'package:flutter/services.dart';

/// Formateadores de input (máscaras) para campos de formulario
/// TextInputFormatters para aplicar máscaras en tiempo real
class InputMasks {
  InputMasks._();

  // ============ TELÉFONO ============
  
  /// Formateador de teléfono: (XXX) XXX-XXXX
  static List<TextInputFormatter> phone() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
      _PhoneNumberFormatter(),
    ];
  }

  // ============ NÚMEROS ============
  
  /// Solo dígitos
  static List<TextInputFormatter> digitsOnly({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  /// Números con decimales
  static List<TextInputFormatter> decimal({int maxDecimals = 2}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,' + maxDecimals.toString() + r'}')),
    ];
  }

  // ============ TEXTO ============
  
  /// Solo letras (sin números ni símbolos)
  static List<TextInputFormatter> lettersOnly() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
    ];
  }

  /// Solo alfanuméricos
  static List<TextInputFormatter> alphanumeric() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
    ];
  }

  /// Email (lowercase, sin espacios)
  static List<TextInputFormatter> email() {
    return [
      FilteringTextInputFormatter.deny(RegExp(r'\s')), // Sin espacios
      LowercaseTextFormatter(),
    ];
  }

  // ============ IDENTIFICADORES ============
  
  /// Serial number (alfanumérico uppercase, guiones)
  static List<TextInputFormatter> serialNumber() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-]')),
      UpperCaseTextFormatter(),
      LengthLimitingTextInputFormatter(20),
    ];
  }

  /// MAC Address: XX:XX:XX:XX:XX:XX
  static List<TextInputFormatter> macAddress() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f:]')),
      LengthLimitingTextInputFormatter(17),
      _MacAddressFormatter(),
    ];
  }

  /// IP Address: XXX.XXX.XXX.XXX
  static List<TextInputFormatter> ipAddress() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      LengthLimitingTextInputFormatter(15),
    ];
  }
}

// ============ CUSTOM FORMATTERS ============

/// Formateador de número telefónico
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 3) buffer.write(') ');
      if (i == 6) buffer.write('-');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formateador de MAC Address
class _MacAddressFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(':', '').toUpperCase();
    
    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 12; i++) {
      if (i > 0 && i % 2 == 0) buffer.write(':');
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Lowercase formatter
class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

/// Uppercase formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
