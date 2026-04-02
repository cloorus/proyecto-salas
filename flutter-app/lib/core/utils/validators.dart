import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Validadores de formularios para BGnius VITA
/// Versión i18n - Soporta múltiples idiomas usando AppLocalizations
class Validators {
  Validators._();

  /// Valida que un campo no esté vacío
  static String? required(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    return null;
  }

  /// Valida formato de correo electrónico
  static String? email(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationEmailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.validationInvalidEmail;
    }
    
    return null;
  }

  /// Valida contraseña segura
  /// Mínimo 8 caracteres, 1 mayúscula, 1 minúscula, 1 número, 1 símbolo
  static String? password(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.validationPasswordRequired;
    }
    
    if (value.length < 8) {
      return AppLocalizations.of(context)!.validationPasswordMinLength;
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppLocalizations.of(context)!.validationPasswordUppercase;
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppLocalizations.of(context)!.validationPasswordLowercase;
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppLocalizations.of(context)!.validationPasswordNumber;
    }
    
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppLocalizations.of(context)!.validationPasswordSymbol;
    }
    
    return null;
  }

  /// Valida que dos contraseñas coincidan
  static String? confirmPassword(String? value, String? originalPassword, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.validationConfirmPassword;
    }
    
    if (value != originalPassword) {
      return AppLocalizations.of(context)!.validationPasswordsNoMatch;
    }
    
    return null;
  }

  /// Valida formato de teléfono
  /// Formato: +XXX XXXX-XXXX
  static String? phone(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    // Remover espacios y guiones para validar
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    if (!cleanPhone.startsWith('+')) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }

  /// 5-30 caracteres, permite letras, números, guiones y espacios
  static String? serialNumber(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    final trimmed = value.trim();
    if (trimmed.length < 5 || trimmed.length > 30) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    // Permitir letras (A-Z, a-z), números (0-9), guiones (-), guiones bajos (_) y espacios
    if (!RegExp(r'^[A-Za-z0-9\-_ ]+$').hasMatch(trimmed)) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }

  /// Valida nombre de dispositivo
  /// Mínimo 3 caracteres
  static String? deviceName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    if (value.trim().length < 3) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }

  /// Valida longitud mínima
  static String? minLength(String? value, int min, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    if (value.trim().length < min) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }

  /// Valida longitud máxima
  static String? maxLength(String? value, int max, BuildContext context) {
    if (value != null && value.trim().length > max) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }

  /// Valida que solo contenga números
  static String? numeric(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return AppLocalizations.of(context)!.validationRequiredField;
    }
    
    return null;
  }
}

