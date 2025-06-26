import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatelessWidget {
  MyJoystick({super.key});
  int x = 0;
  int y = 0;

  double toDegree(double x, double y) {
    return atan2(y, x) * (180 / pi);
  }

  @override
  Widget build(BuildContext context) {
    return Joystick(
      base: JoystickBase(size: 150),
      stick: JoystickStick(size: 30),
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
