class DateUtil {
  /// Returns current IST time (UTC + 5:30)
  static DateTime get nowIST {
    return DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  }

  /// Shifts time +5 hours to achieve 7 PM rollover
  /// For instance, actions at 7:00 PM are treated as midnight of the next day.
  static DateTime get operatingDay {
    return nowIST.add(const Duration(hours: 5));
  }

  /// Returns YYYY-MM-DD for the current operating day
  static String get todayStr {
    final opDay = operatingDay;
    return '${opDay.year}-${opDay.month.toString().padLeft(2, '0')}-${opDay.day.toString().padLeft(2, '0')}';
  }

  /// Useful for testing specific boundaries
  static String testOperatingDay(DateTime inputTimeUtc) {
    final istTime = inputTimeUtc.add(const Duration(hours: 5, minutes: 30));
    final shifted = istTime.add(const Duration(hours: 5));
    return '${shifted.year}-${shifted.month.toString().padLeft(2, '0')}-${shifted.day.toString().padLeft(2, '0')}';
  }
}
