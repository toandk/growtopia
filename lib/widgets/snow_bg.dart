import 'dart:math';

import 'package:flutter/material.dart';

class SnowWidget extends StatefulWidget {
  final int totalSnow;
  final double speed;
  final bool isRunning;

  const SnowWidget(
      {Key? key,
      required this.totalSnow,
      required this.speed,
      required this.isRunning})
      : super(key: key);

  @override
  _SnowWidgetState createState() => _SnowWidgetState();
}

class _SnowWidgetState extends State<SnowWidget>
    with SingleTickerProviderStateMixin {
  final Random _rnd = Random();
  late AnimationController controller;
  late Animation<double> animation;
  List<Snow> _snows = [];
  double angle = 0;
  double W = 0;
  double H = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (controller == null) {
      controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        vsync: this,
        duration: const Duration(milliseconds: 20000),
      );
      controller.addListener(() {
        if (mounted) {
          setState(() {
            update();
          });
        }
      });
    }
    if (!widget.isRunning) {
      controller.stop();
    } else {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _createSnow() {
    _snows = List<Snow>.generate(widget.totalSnow, (i) {
      return Snow(
        x: _rnd.nextDouble() * W,
        y: _rnd.nextDouble() * H,
        r: _rnd.nextDouble() * 4 + 1,
        d: _rnd.nextDouble() * widget.speed,
      );
    });
  }

  void update() {
    print(" update ${widget.isRunning}");
    angle += 0.01;
    if (widget.totalSnow != _snows.length) {
      _createSnow();
    }
    for (var i = 0; i < widget.totalSnow; i++) {
      var snow = _snows[i];
      snow.y += (cos(angle + snow.d) + 1 + snow.r / 2) * widget.speed;
      snow.x += sin(angle) * 2 * widget.speed;
      if (snow.x > W + 5 || snow.x < -5 || snow.y > H) {
        if (i % 3 > 0) {
          _snows[i] = Snow(
            x: _rnd.nextDouble() * W,
            y: -10,
            r: snow.r,
            d: snow.d,
          );
        } else {
          if (sin(angle) > 0) {
            _snows[i] = Snow(
              x: -5,
              y: _rnd.nextDouble() * H,
              r: snow.r,
              d: snow.d,
            );
          } else {
            _snows[i] = Snow(
              x: W + 5,
              y: _rnd.nextDouble() * H,
              r: snow.r,
              d: snow.d,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRunning && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.isRunning && controller.isAnimating) {
      controller.stop();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (_snows.isEmpty) {
          W = constraints.maxWidth;
          H = constraints.maxHeight;
        }
        return CustomPaint(
          willChange: widget.isRunning,
          painter: SnowPainter(isRunning: widget.isRunning, snows: _snows),
          size: Size.infinite,
        );
      },
    );
  }
}

class Snow {
  double x;
  double y;
  double r; // radius
  double d; // density

  Snow({
    required this.x,
    required this.y,
    required this.r,
    required this.d,
  });
}

class SnowPainter extends CustomPainter {
  final List<Snow> snows;
  final bool isRunning;

  SnowPainter({required this.isRunning, required this.snows});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isRunning) return;
    // draw circle
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    for (var i = 0; i < snows.length; i++) {
      var snow = snows[i];
      canvas.drawCircle(Offset(snow.x, snow.y), snow.r, paint);
    }
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => isRunning;
}
