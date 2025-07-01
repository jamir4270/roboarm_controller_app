import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatelessWidget {
  final void Function(StickDragDetails) myListener;
  const MyJoystick({super.key, required this.myListener});

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
