import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatefulWidget {
  const MyJoystick({super.key});

  @override
  State<MyJoystick> createState() => _MyJoystickState();
}

class _MyJoystickState extends State<MyJoystick> {
  int x = 0;
  int y = 0;

  @override
  Widget build(BuildContext context) {
    return Joystick(
      base: JoystickBase(size: 180),
      stick: JoystickStick(size: 50),
      mode: JoystickMode.horizontalAndVertical,
      listener: (details) {
        x -= details.x < 0 && x >= 0 ? 3 : 0;
        x += details.x > 0 && x <= 180 ? 3 : 0;
        y -= details.y < 0 && y >= 0 ? 3 : 0;
        y += details.y > 0 && y <= 180 ? 3 : 0;
      },
    );
  }
}
