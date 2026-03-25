class DateFormatter {
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);

      final weekdays = [
        'segunda-feira',
        'terça-feira',
        'quarta-feira',
        'quinta-feira',
        'sexta-feira',
        'sábado',
        'domingo',
      ];

      final weekday = weekdays[date.weekday - 1];
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');

      return '$weekday, $day/$month/$year, $hour:$minute';
    } catch (e) {
      return dateString;
    }
  }
}
