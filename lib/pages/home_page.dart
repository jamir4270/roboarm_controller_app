import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:roboarm_controller_app/components/instructions_box.dart';
import 'package:roboarm_controller_app/components/my_joystick.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> devices = [];

  String? selectedDevice;
  // Define a more professional and modern color palette
  final Color primaryColor = const Color(
    0xFF2C3E50,
  ); // Dark Blue/Charcoal for primary elements
  final Color accentColor = const Color(
    0xFF3498DB,
  ); // A calming Blue for accents
  final Color backgroundColor = const Color(
    0xFFECF0F1,
  ); // Light Grey for the background
  final Color textColor = const Color(0xFF34495E); // Darker Grey for text
  final Color successColor = const Color(
    0xFF2ECC71,
  ); // Green for success states (e.g., connected)
  final Color warningColor = const Color(
    0xFFE67E22,
  ); // Orange for warning states (e.g., not connected)

  @override
  void initState() {
    super.initState();
    // Simulate fetching devices
    if (devices.isNotEmpty) {
      selectedDevice = devices.first;
    }
  }

  Widget build(BuildContext context) {
    // Create a custom ColorScheme based on the defined palette
    final ColorScheme customColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      error: Colors.red, // Standard error color
      onError: Colors.white,
      background: backgroundColor,
      onBackground: textColor,
      surface: Colors.white,
      onSurface: textColor,
    );

    return Theme(
      data: ThemeData(
        colorScheme: customColorScheme,
        scaffoldBackgroundColor:
            backgroundColor, // Apply background color to the entire scaffold
        appBarTheme: AppBarTheme(
          color: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4.0, // Add a subtle shadow for depth
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 96, color: textColor),
          displayMedium: TextStyle(fontSize: 60, color: textColor),
          displaySmall: TextStyle(fontSize: 48, color: textColor),
          headlineMedium: TextStyle(fontSize: 34, color: textColor),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: textColor),
          bodyMedium: TextStyle(fontSize: 14, color: textColor),
          bodySmall: TextStyle(fontSize: 12, color: textColor),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: textColor, fontSize: 16),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: accentColor, width: 2.0),
            ),
          ),
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            elevation: MaterialStateProperty.all(4),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 6.0, // Increase elevation for a more pronounced button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              15.0,
            ), // Slightly rounded corners
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RoboArm Controller"),
          centerTitle: false, // Align title to the left
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            top: 16,
            right: 24,
            bottom: 24,
          ), // Increased padding for more breathing room
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the start
            children: [
              Row(
                // Distribute space evenly
                children: [
                  Text(
                    "Connection Status:",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Text(
                        "Not Connected",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: warningColor,
                        ), // Use warning color
                      ),
                      const SizedBox(width: 10),
                      DropdownMenu(
                        dropdownMenuEntries: [
                          DropdownMenuEntry<String>(
                            value: "Device 1",
                            label: "Device 1",
                          ),
                          DropdownMenuEntry<String>(
                            value: "Device 2",
                            label: "Device 2",
                          ),
                          DropdownMenuEntry<String>(
                            value: "Device 3",
                            label: "Device 3",
                          ),
                        ],
                        onSelected: (value) {
                          setState(() {
                            selectedDevice = value;
                          });
                        },
                        initialSelection: selectedDevice,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased spacing
              Expanded(
                // Use Expanded to give joysticks available space
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // Use spaceEvenly for balanced spacing
                      children: [MyJoystick(), MyJoystick()],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "XY-Axis Control",
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge, // Larger, bolder text
                        ),
                        Text(
                          "Z-Axis & Clamp Control",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return InstructionsBox(); // Ensure InstructionsBox uses the new theme
              },
            );
          },
          child: const Icon(Icons.info_outline),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
