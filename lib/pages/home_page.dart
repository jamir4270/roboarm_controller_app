import "package:flutter/material.dart";
import "package:bluetooth_classic/bluetooth_classic.dart";
import 'package:bluetooth_classic/models/device.dart';
import "package:roboarm_controller_app/components/instructions_box.dart";
import "package:roboarm_controller_app/components/my_joystick.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool deviceStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RoboArm Controller")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(deviceStatus ? "Connected" : "Not Connected"),
              SizedBox(width: 20),
              ElevatedButton(onPressed: () {}, child: Text("Scan RoboArm")),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [MyJoystick(), SizedBox(height: 30), Text("XY-AXIS")],
              ),
              SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyJoystick(),
                  SizedBox(height: 20),
                  Text("Z-AXIS & CLAMP"),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return InstructionsBox();
            },
          );
        },
        child: Icon(Icons.info_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
