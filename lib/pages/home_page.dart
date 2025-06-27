import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import "package:roboarm_controller_app/components/instructions_box.dart";
import "package:roboarm_controller_app/components/my_joystick.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool deviceStatus = false;
  final _blueClassicPlugin = FlutterBlueClassic(usesFineLocation: true);

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;

  final Set<BluetoothDevice> _scanResults = {};
  StreamSubscription? _scanSubscription;

  bool _isScanning = false;
  int? _connectingToIndex;
  StreamSubscription? _scanningStateSubscription;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _blueClassicPlugin.adapterStateNow;
      _adapterStateSubscription = _blueClassicPlugin.adapterState.listen((
        current,
      ) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription = _blueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
      _scanningStateSubscription = _blueClassicPlugin.isScanning.listen((
        isScanning,
      ) {
        if (mounted) setState(() => _isScanning = _isScanning);
      });
    } catch (e) {
      if (kDebugMode) print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    for (int i = 0; i < scanResults.length; i++) {
      print(scanResults[i].name);
    }

    void displayDevices() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Available Devices"),
            content: SizedBox(
              width: 300.0,
              child: ListView(
                children: [
                  SizedBox(),
                  if (scanResults.isEmpty)
                    const Center(child: Text("No devices found yet"))
                  else
                    for (var (index, result) in scanResults.indexed)
                      ListTile(
                        title: Text(
                          "${result.name ?? "???"} (${result.address})",
                        ),
                        trailing: index == _connectingToIndex
                            ? const CircularProgressIndicator()
                            : Text("${result.rssi} dBm"),
                        onTap: () async {
                          BluetoothConnection? connection;
                          setState(() => _connectingToIndex = index);
                          try {
                            connection = await _blueClassicPlugin.connect(
                              result.address,
                            );
                            if (!this.mounted) return;
                            if (connection != null && connection.isConnected) {
                              if (mounted) {
                                setState(() => _connectingToIndex = null);
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _connectingToIndex = null);
                            }
                            if (kDebugMode) print(e);
                            connection?.dispose();
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(
                                content: Text("Error connecting to device"),
                              ),
                            );
                          }
                        },
                      ),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _blueClassicPlugin.stopScan();
                  },
                  child: Text("Stop"),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("RoboArm Controller")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Adapter State: " + _adapterState.name),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  _blueClassicPlugin.turnOn();
                  _blueClassicPlugin.startScan();
                  displayDevices();
                },
                child: Text("Scan RoboArm"),
              ),
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
