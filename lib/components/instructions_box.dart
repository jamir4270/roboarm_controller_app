import 'package:flutter/material.dart';

class InstructionsBox extends StatelessWidget {
  const InstructionsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Apply background color to the AlertDialog
      backgroundColor: Color(0xFFECF0F1), // Light Grey
      title: const Text(
        "RoboArm Controller Instructions",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF2C3E50), // Dark Grey for the title
          fontWeight: FontWeight.bold, // Make title bold for emphasis
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text(
              "1. Ensure Bluetooth is enabled on your device.",
              style: TextStyle(
                color: Color(0xFF2C3E50),
              ), // Dark Grey for body text
            ),
            SizedBox(height: 8), // Add some spacing between instructions
            Text(
              "2. Click 'Available Devices' button and select the roboarm you want to connect.",
              style: TextStyle(
                color: Color(0xFF2C3E50),
              ), // Dark Grey for body text
            ),
            SizedBox(height: 8),
            Text(
              "3. Use the controls to operate the RoboArm.",
              style: TextStyle(
                color: Color(0xFF2C3E50),
              ), // Dark Grey for body text
            ),
            SizedBox(height: 16), // More spacing before "Controls"
            Text(
              "Controls",
              style: TextStyle(
                // Yellow for emphasis on "Controls" heading
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Left Joystick: S1 (x-axis) and S2 (y-axis) servo motors",
              style: TextStyle(
                color: Color(0xFF2C3E50),
              ), // Dark Grey for control details
            ),
            SizedBox(height: 8),
            Text(
              "Right Joystick: S3 (clamp) and S4 (z-axis) servo motor",
              style: TextStyle(
                color: Color(0xFF2C3E50),
              ), // Dark Grey for control details
            ),
          ],
        ),
      ),
      // Optional: Add actions like a close button for better UX
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Color(
              0xFF1ABC9C,
            ), // Muted Grey/Blue for text button
          ),
          child: const Text("Got It!", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
