import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularTimerWidget extends StatefulWidget {
  final double radius;
  final double lineWidth;
  final Color backgroundColor;
  final Color progressColor;
  final TextStyle? textStyle;
  final Function(CircularTimerWidgetState)? onStateCreated;
  final VoidCallback? onTimerFinished;

  const CircularTimerWidget({
    super.key,
    this.radius = 70.0,
    this.lineWidth = 9.0,
    this.backgroundColor = const Color(0xFFE7F3C2),
    this.progressColor = const Color(0xFFB6D72B),
    this.textStyle,
    this.onStateCreated,
    this.onTimerFinished,
  });

  @override
  State<CircularTimerWidget> createState() => CircularTimerWidgetState();
}

class CircularTimerWidgetState extends State<CircularTimerWidget> {
  int _seconds = 0;
  int _maxSeconds = 30;
  double _percent = 0.0;
  Timer? _timer;
  final _stopwatch = Stopwatch();

  int get seconds => _seconds;
  int get maxSeconds => _maxSeconds;

  @override
  void initState() {
    super.initState();
    widget.onStateCreated?.call(this);
  }

  void start([int seconds = 30]) {
    _maxSeconds = seconds;
    stop(); // Reset antes de iniciar

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _seconds = _stopwatch.elapsed.inSeconds;
        _percent = (_seconds / _maxSeconds).clamp(0.0, 1.0);
      });
      if (_seconds >= _maxSeconds) {
        timer.cancel();
        _stopwatch.stop();
        if (widget.onTimerFinished != null) {
          widget.onTimerFinished!();
        }
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  void restart() {
    stop();
    start(_maxSeconds);
  }

  void stop() {
    _timer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
    if (mounted) {
      setState(() {
        _seconds = 0;
        _percent = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int remainingSeconds = (_maxSeconds - _seconds).clamp(0, _maxSeconds);
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;
    final String timerText =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return CircularPercentIndicator(
      radius: widget.radius,
      lineWidth: widget.lineWidth,
      percent: 1.0 - _percent,
      backgroundColor: widget.backgroundColor,
      progressColor: widget.progressColor,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        timerText,
        style:
            widget.textStyle ??
            const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
      ),
    );
  }
}
