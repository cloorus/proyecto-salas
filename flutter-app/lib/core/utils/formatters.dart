import 'package:intl/intl.dart';

/// Formateadores y utilidades de formato
class Formatters {
  Formatters._();

  /// Formatea un número de teléfono al formato: +XXX XXXX-XXXX
  static String formatPhone(String phone) {
    // Remover todos los caracteres no numéricos excepto +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleaned.isEmpty) return '';
    
    // Si no empieza con +, agregarlo
    if (!cleaned.startsWith('+')) {
      cleaned = '+$cleaned';
    }
    
    // Formatear según longitud
    if (cleaned.length > 4) {
      String countryCode = cleaned.substring(0, 4);
      String remaining = cleaned.substring(4);
      
      if (remaining.length > 4) {
        String firstPart = remaining.substring(0, 4);
        String lastPart = remaining.substring(4);
        return '$countryCode $firstPart-$lastPart';
      } else {
        return '$countryCode $remaining';
      }
    }
    
    return cleaned;
  }

  /// Formatea una fecha al formato dd/MM/yyyy
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatea una fecha y hora al formato dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Formatea solo la hora al formato HH:mm
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Formatea un número de serie (mayúsculas, sin espacios)
  static String formatSerialNumber(String serial) {
    return serial.toUpperCase().replaceAll(' ', '');
  }

  /// Formatea un nombre (primera letra en mayúscula)
  static String formatName(String name) {
    if (name.isEmpty) return '';
    return name.trim().split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Convierte un DateTime a tiempo relativo (hace 5 min, hace 2 horas, etc)
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'hace $years ${years == 1 ? 'año' : 'años'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'hace un momento';
    }
  }

  /// Trunca un texto largo con puntos suspensivos
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formatea bytes a tamaño legible (KB, MB, GB)
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
