import 'package:flutter/material.dart';

class InstructionsBox extends StatelessWidget {
  const InstructionsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "RoboArm Controller Instructions",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("1. Ensure Bluetooth is enabled on your device."),
            Text(
              "2. Click Available Devices button and select the roboarm you want to connect.",
            ),
            Text("3. Use the controls to operate the RoboArm."),
            Text("Controls"),
            Text("Left Joystick: S1(x-axis) and S2(y-axis) servo motors"),
            Text("Right Joystick: S3(clamp) and S4(z-axis) servo motor"),
          ],
        ),
      ),
    );
  }
}
