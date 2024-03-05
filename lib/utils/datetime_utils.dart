import 'package:intl/intl.dart';


class DateTimeUtils {
  const DateTimeUtils._();

  static const DateTimeUtils instance = DateTimeUtils._();

  static const String shortDatePattern = "hh:mm";
  static const String datePattern_1 = "dd-MM-yyyy";
  static const String datePattern_2 = "dd/MM";

  static const String timeSpacer = "\u2022";

  String convertDateToStringDefault(int milliseconds) {
    return DateFormat(shortDatePattern)
        .format(DateTime.fromMillisecondsSinceEpoch(milliseconds * 1000));
  }

  String convertDateToString(DateTime dateTime,
      {String datePattern = shortDatePattern}) {
    return DateFormat(datePattern).format(dateTime);
  }

  // String convertDateToTime(DateTime? pickedTime) {
  //   if (pickedTime == null) {
  //     return LocaleKeys.task_datetimePicker_timePickerTitle.tr;
  //   }

  //   /*
  //     Hiện tại, backend lưu trữ dạng millisecond, nên client tạm quy định
  //     khi chưa chọn time => hour = 0, minute = 0, second = 0
  //   */
  //   if (pickedTime.hour == 0 && pickedTime.minute == 0) {
  //     return "";
  //   }

  //   String _hour =
  //       pickedTime.hour >= 10 ? "${pickedTime.hour}" : "0${pickedTime.hour}";
  //   String _minute = pickedTime.minute >= 10
  //       ? "${pickedTime.minute}"
  //       : "0${pickedTime.minute}";

  //   return "${_hour}h$_minute'";
  // }

  DateTime utc(DateTime dateTime) {
    return dateTime.toUtc();
    // return dateTime = DateTime.utc(dateTime.year, dateTime.month, dateTime.day,
    //     dateTime.hour, dateTime.minute, dateTime.second).subtract(dateTime.timeZoneOffset);
  }

  DateTime _dateNow() {
    final now0 = DateTime.now();
    final now = DateTime(now0.year, now0.month, now0.day);
    return now;
  }

  bool _isYesterday(DateTime input) {
    final yesterday = _dateNow().subtract(const Duration(days: 1));

    return DateTime(input.year, input.month, input.day).isSameDate(yesterday);
  }

  bool isToday(int milliseconds) {
    DateTime input = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return DateTime(input.year, input.month, input.day)
        .isSameDate(_dateNow());
  }

  bool _isTomorrow(DateTime input) {
    final tomorrow = _dateNow().add(const Duration(days: 1));

    return DateTime(input.year, input.month, input.day).isSameDate(tomorrow);
  }

  bool isInPast(int milliseconds) {
    DateTime input = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    return input.isBefore(DateTime.now());
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool hasTime() {
    return hour != 0 && minute != 0;
  }
}
