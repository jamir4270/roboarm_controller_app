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

  // IMPORTANT: Declare your BluetoothConnection as a state variable
  // It should be nullable because it's null before connection and after disconnection.
  BluetoothConnection? _currentConnection;

  final leftController = JoystickController();
  final rightController = JoystickController();

  int x_servo = 90;
  int y_servo = 90;
  int z_servo = 90;
  int clamp_servo = 90;

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
        if (mounted)
          setState(() => _isScanning = isScanning); // Corrected this line
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
    _currentConnection
        ?.dispose(); // Dispose the connection when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDevice> scanResults = _scanResults.toList();

    // Remove this line. The connection will be stored in _currentConnection.
    // BluetoothConnection? connection; // <-- REMOVE THIS LINE

    for (int i = 0; i < scanResults.length; i++) {
      print(scanResults[i].name);
    }

    void displayDevices() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Available Devices",
            ), // Added const for efficiency
            content: SizedBox(
              width: 300.0,
              child: ListView(
                children: [
                  const SizedBox(), // Added const
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
                          setState(() => _connectingToIndex = index);
                          // Ensure previous connection is disposed before trying new one
                          _currentConnection?.dispose();
                          _currentConnection =
                              null; // Clear previous connection

                          try {
                            _currentConnection = await _blueClassicPlugin
                                .connect(result.address);

                            if (!mounted)
                              return; // Check mounted after async operation

                            if (_currentConnection != null &&
                                _currentConnection!.isConnected) {
                              if (mounted) {
                                setState(() {
                                  _connectingToIndex = null;
                                  deviceStatus = true; // Update device status
                                });
                              }
                              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                                const SnackBar(
                                  content: Text("Connected to device"),
                                ),
                              );
                              print(
                                "Successfully connected to ${result.name} at ${result.address}",
                              );

                              // You might want to set up an input stream listener here
                              // to receive data from the Bluetooth device.
                              _currentConnection!.input
                                  ?.listen((Uint8List data) {
                                    // Handle incoming data from the device
                                    print(
                                      'Received from device: ${String.fromCharCodes(data)}',
                                    );
                                  })
                                  .onDone(() {
                                    // Handle disconnection from the device's side
                                    if (mounted) {
                                      setState(() {
                                        _currentConnection = null;
                                        deviceStatus = false;
                                      });
                                      ScaffoldMessenger.maybeOf(
                                        context,
                                      )?.showSnackBar(
                                        const SnackBar(
                                          content: Text("Device disconnected."),
                                        ),
                                      );
                                    }
                                  });

                              try {
                                // Send a test message
                                String testCommand =
                                    "Hello from Flutter App!\n";
                                // Use _currentConnection! for non-nullable access after null check
                                _currentConnection!.output?.add(
                                  Uint8List.fromList(testCommand.codeUnits),
                                );
                                print("Sent: '$testCommand'");
                              } catch (e) {
                                print("Error during initial data exchange: $e");
                                ScaffoldMessenger.maybeOf(
                                  context,
                                )?.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error during initial data exchange: ${e.toString()}",
                                    ),
                                  ),
                                );
                                _currentConnection
                                    ?.dispose(); // Dispose on error
                                if (mounted)
                                  setState(() => deviceStatus = false);
                              }
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _connectingToIndex = null);
                            }
                            if (kDebugMode) print("Connection error: $e");
                            _currentConnection?.dispose(); // Dispose on error
                            _currentConnection =
                                null; // Ensure it's null on failure
                            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                              const SnackBar(
                                content: Text("Error connecting to device"),
                              ),
                            );
                            if (mounted) setState(() => deviceStatus = false);
                          } finally {
                            if (mounted)
                              setState(() => _connectingToIndex = null);
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
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Stop Scan"), // Added const
                ),
              ),
            ],
          );
        },
      );
    }

    void leftJoystickMovement(StickDragDetails details) {
      // Use the class-level _currentConnection variable
      setState(() {
        // Corrected logic for servo limits (you had x_servo += 3 if x_servo >= 0, etc.)
        // This makes sure it decrements when details.x is negative and increments when positive.
        // Also, ensures it stays within 0-180 range.
        if (details.x < 0) {
          // Moving left
          x_servo = (x_servo - 3).clamp(0, 180);
        } else if (details.x > 0) {
          // Moving right
          x_servo = (x_servo + 3).clamp(0, 180);
        }

        if (details.y < 0) {
          // Moving up (typically negative y for up)
          y_servo = (y_servo - 3).clamp(0, 180);
        } else if (details.y > 0) {
          // Moving down (typically positive y for down)
          y_servo = (y_servo + 3).clamp(0, 180);
        }

        // Only send if there's an active connection
        if (_currentConnection != null && _currentConnection!.isConnected) {
          // You should send both x and y values together if they are part of the same control
          // Or, send them individually based on which one changed
          // For simplicity, let's send both x and y every time the joystick moves
          _currentConnection!.writeString("S1-${x_servo}\n");
          print("S1${x_servo}");
          _currentConnection!.writeString("S2-${y_servo}\n");
          print("S2${y_servo}");

          // If you only want to send when the value actually changes:
          // if (previous_x_servo != x_servo) { _currentConnection!.writeString("S1${x_servo}\n"); }
          // if (previous_y_servo != y_servo) { _currentConnection!.writeString("S2${y_servo}\n"); }
          // You'd need to store previous_x_servo and previous_y_servo as state variables too.
        } else {
          print("No active Bluetooth connection to send joystick data.");
        }
      });
    }

    void rightJoystickMovement(StickDragDetails details) {
      // Use the class-level _currentConnection variable
      setState(() {
        // Corrected logic for servo limits
        if (details.x < 0) {
          // Moving left (controls Z for right joystick)
          z_servo = (z_servo - 3).clamp(0, 180);
        } else if (details.x > 0) {
          // Moving right (controls Z for right joystick)
          z_servo = (z_servo + 3).clamp(0, 180);
        }

        if (details.y < 0) {
          // Moving up (controls Clamp for right joystick)
          clamp_servo = (clamp_servo - 3).clamp(0, 180);
        } else if (details.y > 0) {
          // Moving down (controls Clamp for right joystick)
          clamp_servo = (clamp_servo + 3).clamp(0, 180);
        }

        // Only send if there's an active connection
        if (_currentConnection != null && _currentConnection!.isConnected) {
          _currentConnection!.writeString("S3-${z_servo}\n");
          print("S3${z_servo}");
          _currentConnection!.writeString("S4-${clamp_servo}\n");
          print("S4${clamp_servo}");
        } else {
          print("No active Bluetooth connection to send joystick data.");
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("RoboArm Controller")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Adapter State: " + _adapterState.name),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  _blueClassicPlugin.turnOn();
                  _blueClassicPlugin.startScan();
                  displayDevices();
                },
                child: const Text("Scan RoboArm"),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyJoystick(
                    myController: leftController,
                    myListener: leftJoystickMovement,
                  ),
                  const SizedBox(height: 30),
                  const Text("XY-AXIS"),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyJoystick(
                    myController: rightController,
                    myListener: rightJoystickMovement,
                  ),
                  const SizedBox(height: 20),
                  const Text("Z-AXIS & CLAMP"),
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
              return const InstructionsBox(); // Added const
            },
          );
        },
        child: const Icon(Icons.info_rounded), // Added const
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
