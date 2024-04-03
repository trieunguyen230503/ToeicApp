import 'dart:async';
import 'package:apptoeic/utils/snack_bar.dart';
import 'package:flutter/material.dart';

class CountDownTime extends StatefulWidget {
  CountDownTime(
      {super.key, required this.secondLeft, required this.updateSecondLeft});

  var secondLeft;
  final Function(int) updateSecondLeft;

  @override
  State<CountDownTime> createState() => _CountDownTimeState();
}

class _CountDownTimeState extends State<CountDownTime> {
  late Timer _timer;

  void startCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        //print('TIME BỘ ĐẾM: ${widget.secondLeft}');
        if (widget.secondLeft > 0) {
          widget.updateSecondLeft(--widget.secondLeft);
        } else {
          _timer.cancel();
        }

        if (widget.secondLeft == 60) {
          openSnackbar(context, '1 minute left', Colors.red);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCountDown();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  String formatTime(int second) {
    int minutes = second ~/ 60;
    int remainingSeconds = second % 60;
    String minuteStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondStr =
        remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';

    return '$minuteStr : $secondStr';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(widget.secondLeft),
      style: TextStyle(
          fontSize: 18,
          color: widget.secondLeft > 60 ? Colors.white : Colors.red),
    );
  }
}
