import 'package:intl/intl.dart';

class DateFormatter {
  /// Formatea una fecha según el formato proporcionado.
  /// Si no se proporciona un formato, usa "yyyy-MM-dd" por defecto.
  static String format(DateTime? date, {String format = "yyyy-MM-dd"}) {
    if (date == null) {
      return "Fecha no válida"; // Manejo de fechas nulas
    }
    return DateFormat(format).format(date);
  }

  /// Convierte una cadena de texto a un objeto DateTime según el formato proporcionado.
  /// Si no se proporciona un formato, usa "yyyy-MM-dd" por defecto.
  static DateTime? parse(String? dateString, {String format = "yyyy-MM-dd"}) {
    if (dateString == null || dateString.isEmpty) {
      return null; // Manejo de cadenas nulas o vacías
    }
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      print("Error al parsear la fecha: $e");
      return null;
    }
  }

  /// Devuelve el nombre del mes en texto (ej: "Mayo") a partir de un DateTime.
  /// Por defecto devuelve el mes en español, pero puedes cambiar el locale si lo necesitas.
  static String monthName(String? date, {String locale = 'es'}) {
    if (date == null) return "Fecha no válida";
    final parsedDate = parse(date);
    return DateFormat.MMMM(locale).format(parsedDate!);
  }

  static DateTime subtractOneMonth(String date) {
    final parsedDate = parse(date);
    int year = parsedDate!.year;
    int month = parsedDate.month - 1;
    // Si el mes es enero, retrocede al diciembre del año anterior
    if (month == 0) {
      month = 12;
      year -= 1;
    }
    // Ajusta el día si el mes anterior tiene menos días que el actual
    int day = parsedDate.day;
    int lastDayOfPrevMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfPrevMonth) {
      day = lastDayOfPrevMonth;
    }
    return DateTime(year, month, day);
  }
}
