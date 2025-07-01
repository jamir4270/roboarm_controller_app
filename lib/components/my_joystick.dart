import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class MyJoystick extends StatelessWidget {
  final void Function(StickDragDetails) myListener;
  const MyJoystick({super.key, required this.myListener});

  @override
  Widget build(BuildContext context) {
    return Joystick(
      includeInitialAnimation: false, // As per your example
      // The base of the joystick (the static circle)
      base: JoystickBase(
        size: 180,
        decoration: JoystickBaseDecoration(
          color: Color(
            0xFF8C92AC,
          ).withOpacity(0.8), // Muted Grey/Blue with slight transparency
          // We can't directly apply 'border' or 'boxShadow' here
          // as JoystickBaseDecoration only exposes 'color'.
          // If you need more complex base styling, you might need to wrap
          // the Joystick in a Container and apply decoration there,
          // or check the flutter_joystick package for updates.
        ),
        arrowsDecoration: JoystickArrowsDecoration(
          color: Color(0xFF2C3E50), // Dark Grey/Almost Black for arrows
          enableAnimation: false, // As per your example
        ),
      ),
      // The stick (the movable part)
      stick: JoystickStick(
        decoration: JoystickStickDecoration(
          color: Color(0xFFFFD700), // Yellow for the stick
          shadowColor: Colors.black.withOpacity(
            0.4,
          ), // Stronger shadow for the stick (from our scheme)
        ),
        // Similar to the base, direct 'border' not available here.
      ),
      mode: JoystickMode.horizontalAndVertical,
      listener: (details) {
        myListener(details);
      },
    );
  }
}
