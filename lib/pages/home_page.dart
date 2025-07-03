import "dart:async";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import "package:flutter_joystick/flutter_joystick.dart";
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

  BluetoothConnection? _currentConnection;

  int x_servo = 90;
  int y_servo = 90;
  int z_servo = 90;
  int clamp_servo = 90;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _blueClassicPlugin.turnOn();
    _blueClassicPlugin.startScan();
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
        if (mounted) {
          setState(() => _isScanning = isScanning);
        }
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
    _currentConnection?.dispose();
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
            backgroundColor: Color(0xFFECF0F1),
            title: const Text(
              "Available Devices",
              style: TextStyle(color: Color(0xFF2C3E50)),
            ),
            content: SizedBox(
              width: 300.0,
              child: ListView(
                children: [
                  const SizedBox(),
                  if (scanResults.isEmpty)
                    const Center(
                      child: Text(
                        "No devices found yet",
                        style: TextStyle(color: Color(0xFF2C3E50)),
                      ),
                    )
                  else
                    for (var (index, result) in scanResults.indexed)
                      ListTile(
                        title: Text(
                          "${result.name ?? "???"} (${result.address})",
                          style: TextStyle(color: Color(0xFF2C3E50)),
                        ),
                        trailing: index == _connectingToIndex
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFFD700),
                                ),
                              )
                            : Text(
                                "${result.rssi} dBm",
                                style: TextStyle(color: Color(0xFF8C92AC)),
                              ),
                        onTap: () async {
                          setState(() => _connectingToIndex = index);
                          _currentConnection?.dispose();
                          _currentConnection = null;

                          try {
                            _currentConnection = await _blueClassicPlugin
                                .connect(result.address);

                            if (!mounted) {
                              return;
                            }

                            if (_currentConnection != null &&
                                _currentConnection!.isConnected) {
                              if (mounted) {
                                setState(() {
                                  _connectingToIndex = null;
                                  deviceStatus = true;
                                });
                              }
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                const SnackBar(
                                  content: Text("Connected to device"),
                                  backgroundColor: Color(0xFF1ABC9C),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _connectingToIndex = null);
                            }
                            if (kDebugMode) print("Connection error: $e");
                            _currentConnection?.dispose();
                            _currentConnection = null;
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(
                                content: Text("Error connecting to device"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            if (mounted) setState(() => deviceStatus = false);
                          } finally {
                            if (mounted) {
                              setState(() => _connectingToIndex = null);
                            }
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
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8C92AC),
                    foregroundColor: Color(0xFFECF0F1),
                  ),
                  child: const Text("Stop Scan"),
                ),
              ),
            ],
          );
        },
      );
    }

    void leftJoystickMovement(StickDragDetails details) {
      setState(() {
        if (_currentConnection != null && _currentConnection!.isConnected) {
          if (details.x < 0) {
            x_servo = (x_servo - 3).clamp(0, 180);
            _currentConnection!.writeString("S1-${x_servo}\n");
            print("S1${x_servo}");
          } else if (details.x > 0) {
            x_servo = (x_servo + 3).clamp(0, 180);
            _currentConnection!.writeString("S1-${x_servo}\n");
            print("S1${x_servo}");
          }

          if (details.y < 0) {
            y_servo = (y_servo - 3).clamp(0, 180);
            _currentConnection!.writeString("S2-${y_servo}\n");
            print("S2${y_servo}");
          } else if (details.y > 0) {
            y_servo = (y_servo + 3).clamp(0, 180);
            _currentConnection!.writeString("S2-${y_servo}\n");
            print("S2${y_servo}");
          }
        }
      });
    }

    void rightJoystickMovement(StickDragDetails details) {
      setState(() {
        if (_currentConnection != null && _currentConnection!.isConnected) {
          if (details.y < 0) {
            z_servo = (z_servo + 3).clamp(0, 180);
            _currentConnection!.writeString("S4-${z_servo}\n");
            print("S4${z_servo}");
          } else if (details.y > 0) {
            z_servo = (z_servo - 3).clamp(0, 180);
            _currentConnection!.writeString("S4-${z_servo}\n");
            print("S1${z_servo}");
          }

          if (details.x < 0) {
            clamp_servo = (clamp_servo - 3).clamp(0, 180);
            _currentConnection!.writeString("S3-${clamp_servo}\n");
            print("S3${clamp_servo}");
          } else if (details.x > 0) {
            clamp_servo = (clamp_servo + 3).clamp(0, 180);
            _currentConnection!.writeString("S3-${clamp_servo}\n");
            print("S3${clamp_servo}");
          }
        }
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFECF0F1),
      appBar: AppBar(
        title: const Text(
          "RoboArm Controller",
          style: TextStyle(color: Color(0xFFECF0F1)),
        ),
        backgroundColor: Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Color(0xFFECF0F1)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Adapter State: " + _adapterState.name,
                  style: TextStyle(color: Color(0xFF2C3E50)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _blueClassicPlugin.turnOn();
                    _blueClassicPlugin.startScan();
                    displayDevices();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD700),
                    foregroundColor: Color(0xFF2C3E50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Available Devices"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyJoystick(myListener: leftJoystickMovement),
                  const SizedBox(height: 20),
                  const Text(
                    "XY-AXIS",
                    style: TextStyle(color: Color(0xFF2C3E50)),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyJoystick(myListener: rightJoystickMovement),
                  const SizedBox(height: 20),
                  const Text(
                    "Z-AXIS & CLAMP",
                    style: TextStyle(color: Color(0xFF2C3E50)),
                  ),
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
              return const InstructionsBox();
            },
          );
        },
        backgroundColor: Color(0xFF1ABC9C),
        foregroundColor: Color(0xFFECF0F1),
        child: const Icon(Icons.info_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
