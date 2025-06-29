import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatelessWidget {
  final myController;
  final void Function(StickDragDetails) myListener;
  MyJoystick({super.key, required this.myController, required this.myListener});

  int x = 0;
  int y = 0;

  @override
  Widget build(BuildContext context) {
    return Joystick(
      base: JoystickBase(size: 180),
      stick: JoystickStick(size: 50),
      mode: JoystickMode.horizontalAndVertical,
      listener: (details) {
        myListener(details);
      },
    );
  }
}
