import 'dart:async';

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
  late Timer _timer;
  Duration _timeRemaining = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining.inSeconds > 0) {
          _timeRemaining -= Duration(seconds: 1);
        } else {
          _timeRemaining = Duration(minutes: 5);
        }
      });
    });
  }

  List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue
  ];

  @override
  Widget build(BuildContext context) {
    List<double> percent = [
      (_timeRemaining.inSeconds / (5 * 60)),
      (_timeRemaining.inSeconds / (4 * 60)),
      (_timeRemaining.inSeconds / (3 * 60)),
      (_timeRemaining.inSeconds / (2 * 60)),
      (_timeRemaining.inSeconds / (1 * 60)),
    ];
    percent = percent.map((value) => value.clamp(0.0, 1.0)).toList();
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    " ${_timeRemaining.inMinutes}:${(_timeRemaining.inSeconds % 60).toString().padLeft(2, '0')}"),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Expanded(
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: 8.0,
                          animationDuration:
                              _timeRemaining.inSeconds <= 5 ? 1000 : 0,
                          percent: percent[i],
                          progressColor: colors[i],
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  // void linear(){
  //   switch(_timeRemaining){
  //     case 20: if (_timeRemaining == 20){

  //     }
  //   }
  // }
}
