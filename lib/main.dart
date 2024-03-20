import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late String _timeStringNow;
  late DateTime _currentTime;
  late Timer _timer;
  late Duration _timeRemainingDown;
  late DateTime _startTime;
  bool _countUpFinished = false;

  @override
  void initState() {
    _timeRemainingDown = const Duration(minutes: 30);
    _startTime = DateTime.now();
    _dateTime();
    _startCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _dateTime();
      if (!_countUpFinished) {
        _checkCountUp();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _dateTime() {
    _currentTime = DateTime.now();
    setState(() {
      _timeStringNow = DateFormat('hh:mm:ss').format(_currentTime);
    });
  }

/////////////////////////////////////////////////////////////////////////////// count down
  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemainingDown.inSeconds > 0) {
          _timeRemainingDown -= const Duration(seconds: 1);
        } else {
          _timeRemainingDown = const Duration(minutes: 30);
          _startTime = DateTime.now();
        }
      });
    });
  }

  void _checkCountUp() {
    final Duration elapsedTime = _currentTime.difference(_startTime);
    if (elapsedTime.inMinutes >= 30) {
      setState(() {
        _countUpFinished = true;
      });
      _timer.cancel();
    }
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String formatDuration(Duration duration) {
    return '${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  String calculateCountUp() {
    final Duration elapsedTime = _currentTime.difference(_startTime);
    return '${twoDigits(elapsedTime.inMinutes)}:${twoDigits(elapsedTime.inSeconds.remainder(60))}';
  }

  double calculatePercent(int index) {
    final int elapsedTimeInMinutes =
        _currentTime.difference(_startTime).inMinutes;
    final int interval = elapsedTimeInMinutes ~/ 6;
    if (interval >= index) {
      return 1.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Time now: $_timeStringNow"),
                Text("Countdown: ${formatDuration(_timeRemainingDown)}"),
                Text("Count Up: ${calculateCountUp()}"),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Expanded(
                        child: Container(
                          child: LinearPercentIndicator(
                            animation: true,
                            lineHeight: 8.0,
                            animationDuration: aa(),
                            percent: calculatePercent(i),
                            progressColor: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int aa() {
    double totalDurationInMinutes = 0;
    for (int i = 0; i < 5; i++) {
      totalDurationInMinutes +=
          calculatePercent(i) > 0 ? 4 * calculatePercent(i) : 0;
    }
    return (totalDurationInMinutes * 60 * 1000).toInt();
  }
}
