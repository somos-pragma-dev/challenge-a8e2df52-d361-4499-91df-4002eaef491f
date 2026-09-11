library;

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class DateTimeUtils {
  static const String iso8601Format = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  static const String dateOnlyFormat = 'yyyy-MM-dd';
  static const String timeOnlyFormat = 'HH:mm:ss';
  static const String displayFormat = 'dd/MM/yyyy HH:mm';
  static const String syncTimestampFormat = 'yyyy-MM-dd HH:mm:ss';

  static String nowUtc() {
    return DateTime.now().toUtc().toIso8601String();
  }

  static String nowLocal() {
    return DateTime.now().toIso8601String();
  }

  static DateTime parseIso8601(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime parseIso8601Utc(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now().toUtc();
    }
    try {
      final parsed = DateTime.parse(dateString);
      return parsed.toUtc();
    } catch (e) {
      return DateTime.now().toUtc();
    }
  }

  static String formatForSync(DateTime dateTime) {
    return '${dateTime.toUtc().year}-'
        '${_twoDigits(dateTime.toUtc().month)}-${'
        '${_twoDigits(dateTime.toUtc().day)} ${'
        '${_twoDigits(dateTime.toUtc().hour)}:${'
        '${_twoDigits(dateTime.toUtc().minute)}:${'
        '${_twoDigits(dateTime.toUtc().second)}';
  }

  static String formatForDisplay(DateTime dateTime) {
    return '${_twoDigits(dateTime.day)}/${'
        '${_twoDigits(dateTime.month)}/${'
        '${dateTime.year} ${'
        '${_twoDigits(dateTime.hour)}:${'
        '${_twoDigits(dateTime.minute)}';
  }

  static String formatDateOnly(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}';
  }

  static String formatTimeOnly(DateTime dateTime) {
    return '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  static String formatWithTimezone(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final offset = dateTime.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs();
    final minutes = (offset.inMinutes.abs() % 60);
    return '${utc.toIso8601String()}${sign}${_twoDigits(hours)}:${_twoDigits(minutes)}';
  }

  static String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  static bool isSameHour(DateTime date1, DateTime date2) {
    return isSameDay(date1, date2) && date1.hour == date2.hour;
  }

  static bool isExpired(DateTime date, Duration maxAge) {
    final now = DateTime.now();
    return now.difference(date) > maxAge;
  }

  static bool isExpiredUtc(DateTime utcDate, Duration maxAge) {
    final now = DateTime.now().toUtc();
    return now.difference(utcDate) > maxAge;
  }

  static Duration timeSince(DateTime date) {
    return DateTime.now().difference(date);
  }

  static Duration timeSinceUtc(DateTime utcDate) {
    return DateTime.now().toUtc().difference(utcDate);
  }

  static String timeAgo(DateTime date) {
    final duration = timeSince(date);
    return _formatDuration(duration);
  }

  static String timeAgoUtc(DateTime utcDate) {
    final duration = timeSinceUtc(utcDate);
    return _formatDuration(duration);
  }

  static String _formatDuration(Duration duration) {
    if (duration.inDays > 365) {
      final years = (duration.inDays / 365).floor();
      return '$years año${years > 1 ? 's' : ''}';
    } else if (duration.inDays > 30) {
      final months = (duration.inDays / 30).floor();
      return '$months mes${months > 1 ? 'es' : ''}';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} día${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hora${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minuto${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'menos de un minuto';
    }
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }

  static bool isWithinRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  static bool isValidDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return false;
    }
    try {
      DateTime.parse(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  static DateTime addBusinessDays(DateTime date, int days) {
    var result = date;
    var remaining = days;
    while (remaining > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && 
          result.weekday != DateTime.sunday) {
        remaining--;
      }
    }
    return result;
  }

  static int businessDaysBetween(DateTime from, DateTime to) {
    var count = 0;
    var current = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    while (current.isBefore(end)) {
      current = current.add(const Duration(days: 1));
      if (current.weekday != DateTime.saturday && 
          current.weekday != DateTime.sunday) {
        count++;
      }
    }
    return count;
  }

  static DateTime fromTimestampMillis(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static DateTime fromTimestampMicros(int micros) {
    return DateTime.fromMicrosecondsSinceEpoch(micros);
  }

  static int toTimestampMillis(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static int toTimestampMicros(DateTime date) {
    return date.microsecondsSinceEpoch;
  }

  static String generateSyncTimestamp() {
    return formatForSync(DateTime.now().toUtc());
  }

  static String generateVersionId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  static DateTime minDate(List<DateTime> dates) {
    if (dates.isEmpty) {
      return DateTime.now();
    }
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  static DateTime maxDate(List<DateTime> dates) {
    if (dates.isEmpty) {
      return DateTime.now();
    }
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  static bool isDateInFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  static bool isDateInPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  static bool isUtcDateInFuture(DateTime utcDate) {
    return utcDate.isAfter(DateTime.now().toUtc());
  }

  static bool isUtcDateInPast(DateTime utcDate) {
    return utcDate.isBefore(DateTime.now().toUtc());
  }

  static DateTime convertToLocal(DateTime utcDate) {
    return utcDate.toLocal();
  }

  static DateTime convertToUtc(DateTime localDate) {
    return localDate.toUtc();
  }

  static String formatRelative(DateTime date) {
    if (isToday(date)) {
      return 'Hoy, ${formatTimeOnly(date)}';
    } else if (isYesterday(date)) {
      return 'Ayer, ${formatTimeOnly(date)}';
    } else if (isTomorrow(date)) {
      return 'Mañana, ${formatTimeOnly(date)}';
    } else {
      return formatForDisplay(date);
    }
  }

  static Duration parseDuration(String? durationString) {
    if (durationString == null || durationString.isEmpty) {
      return Duration.zero;
    }
    try {
      final parts = durationString.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: int.parse(parts[0]),
          seconds: int.parse(parts[1]),
        );
      }
      return Duration.zero;
    } catch (e) {
      return Duration.zero;
    }
  }

  static String durationToString(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  static DateTime nextSyncTime(DateTime lastSync, Duration interval) {
    return lastSync.add(interval);
  }

  static bool shouldSync(DateTime? lastSync, Duration interval) {
    if (lastSync == null) {
      return true;
    }
    return DateTime.now().isAfter(lastSync.add(interval));
  }

  static int calculateRetryDelay(int attempt, {int baseDelayMs = 1000, int maxDelayMs = 30000}) {
    final delay = baseDelayMs * (1 << (attempt - 1));
    return delay > maxDelayMs ? maxDelayMs : delay;
  }

  static DateTime calculateNextRetry(int attempt, {int baseDelayMs = 1000}) {
    final delayMs = calculateRetryDelay(attempt, baseDelayMs: baseDelayMs);
    return DateTime.now().add(Duration(milliseconds: delayMs));
  }

  static bool isWithinSyncWindow(DateTime syncTime, Duration window) {
    final now = DateTime.now();
    final windowStart = syncTime.subtract(window);
    final windowEnd = syncTime.add(window);
    return now.isAfter(windowStart) && now.isBefore(windowEnd);
  }

  static Map<String, dynamic> dateToMap(DateTime date) {
    return {
      'iso8601': date.toIso8601String(),
      'millis': date.millisecondsSinceEpoch,
      'utc': date.toUtc().toIso8601String(),
      'local': date.toLocal().toIso8601String(),
      'year': date.year,
      'month': date.month,
      'day': date.day,
      'hour': date.hour,
      'minute': date.minute,
      'second': date.second,
      'weekday': date.weekday,
      'isUtc': date.isUtc,
    };
  }

  static DateTime dateFromMap(Map<String, dynamic> map) {
    if (map.containsKey('millis')) {
      return DateTime.fromMillisecondsSinceEpoch(map['millis'] as int);
    } else if (map.containsKey('iso8601')) {
      return DateTime.parse(map['iso8601'] as String);
    }
    return DateTime.now();
  }
}