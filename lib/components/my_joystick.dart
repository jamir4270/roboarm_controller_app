import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatelessWidget {
  const MyJoystick({super.key});

  double toDegree(double x, double y) {
    return atan2(y, x) * (180 / pi);
  }

  @override
  Widget build(BuildContext context) {
    return Joystick(
      mode: JoystickMode.horizontalAndVertical,
      listener: (details) {
        // Here you can handle the joystick movement
        // For example, send the details to your RoboArm controller
        print('Joystick moved: ${toDegree(details.x, details.y)} degrees');
      },
    );
  }
}
