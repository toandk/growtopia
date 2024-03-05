import 'package:flutter/material.dart';

class TimerText extends StatelessWidget {
  final int time; // seconds
  final TextStyle? style;
  const TimerText({Key? key, required this.time, required this.style})
      : super(key: key);

  String _toString(int num) {
    if (num < 10) return "0$num";
    return num.toString();
  }

  @override
  Widget build(BuildContext context) {
    int hour = (time / 3600).truncate();
    int minute = ((time - (hour * 60 * 60)) / 60).truncate();
    int seconds = (time - hour * 60 * 60 - minute * 60);
    String str =
        "${_toString(hour)}:${_toString(minute)}:${_toString(seconds)}";
    return Text(str, style: style);
  }
}
