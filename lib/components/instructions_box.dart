import 'package:flutter/material.dart';

class InstructionsBox extends StatelessWidget {
  const InstructionsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "RoboArm Bluetooth Controller Instructions",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text("1. Ensure Bluetooth is enabled on your device."),
            Text("2. Pair with the RoboArm device in your Bluetooth settings."),
            Text("3. Open the app and connect to the RoboArm."),
            Text("4. Use the controls to operate the RoboArm."),
            Text("5. Disconnect when finished."),
          ],
        ),
      ),
    );
  }
}
