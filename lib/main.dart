// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulam Spiral',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const UlamSpiral(),
    );
  }
}

class UlamSpiral extends StatefulWidget {
  const UlamSpiral({Key? key}) : super(key: key);

  @override
  State<UlamSpiral> createState() => _UlamSpiralState();
}

class _UlamSpiralState extends State<UlamSpiral> with TickerProviderStateMixin {
  final int noOfIterations = 5000;

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10000),
    );
    animation = IntTween(begin: 0, end: noOfIterations).animate(controller);
    controller.forward();
  }

  bool isFullScreen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            foregroundPainter: UlamCustomPainter(animation: animation),
          ),
          Align(
            alignment: const Alignment(0.95, -0.95),
            child: IconButton(
              onPressed: () {
                if (isFullScreen) {
                  isFullScreen = false;
                  document.exitFullscreen();
                } else {
                  isFullScreen = true;
                  document.documentElement?.requestFullscreen();
                }
              },
              icon: Icon(
                isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                size: 40,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UlamCustomPainter extends CustomPainter {
  final Animation animation;
  const UlamCustomPainter({
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.4;

    const int step = 10;
    const double radius = 3;
    int noOfStepsTaken = 0;
    int noOfStepsForPreviousTurn = 0;
    Direction direction = Direction.top;

    Offset startingOffset = Offset(
      size.width / 2,
      size.height / 2,
    );

    Offset endingOffset = Offset(
      size.width / 2 + step,
      size.height / 2,
    );

    for (int i = 0; i < animation.value; i++) {
      if (isPrime(i + 1)) {
        canvas.drawCircle(startingOffset, radius, paint);
      }
      canvas.drawLine(startingOffset, endingOffset, paint);

      startingOffset = endingOffset;

      if (noOfStepsTaken > noOfStepsForPreviousTurn) {
        if (direction == Direction.top) {
          direction = Direction.left;
        } else if (direction == Direction.left) {
          direction = Direction.bottom;
        } else if (direction == Direction.bottom) {
          direction = Direction.right;
        } else if (direction == Direction.right) {
          direction = Direction.top;
        }
        if (direction == Direction.left || direction == Direction.right) {
          noOfStepsForPreviousTurn = noOfStepsTaken;
        }
        noOfStepsTaken = 0;
      }
      noOfStepsTaken++;

      switch (direction) {
        case Direction.top:
          endingOffset = Offset(
            startingOffset.dx,
            startingOffset.dy - step,
          );
          break;
        case Direction.left:
          endingOffset = Offset(
            startingOffset.dx - step,
            startingOffset.dy,
          );
          break;
        case Direction.bottom:
          endingOffset = Offset(
            startingOffset.dx,
            startingOffset.dy + step,
          );

          break;
        case Direction.right:
          endingOffset = Offset(
            startingOffset.dx + step,
            startingOffset.dy,
          );
          break;
        default:
      }
    }
  }

  @override
  bool shouldRepaint(UlamCustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(UlamCustomPainter oldDelegate) => false;
}

bool isPrime(int number) {
  if (number == 2) {
    return true;
  }
  if (number == 1) {
    return false;
  }

  for (var i = 2; i <= number / 2; i++) {
    if (number % i == 0) {
      return false;
    }
  }

  return true;
}

enum Direction { left, right, top, bottom }