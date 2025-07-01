
# RoboArm Controller App

## Overview

Welcome to the `roboarm_controller_app` repository! This project features a RoboArm Controller mobile application, developed using Flutter, designed to provide intuitive control over an Arduino-based robotic arm. This app specifically supports robotic arms utilizing 4 servo motors, allowing for precise and independent control of each joint. The app facilitates seamless communication with the robotic arm via an HC-05 Bluetooth module, enabling users to manipulate the arm's movements with virtual joysticks directly from their mobile device.

This repository is publicly available, encouraging collaboration, learning, and further development within the robotics and mobile app community.

## Features

* **Intuitive Joystick Control:** Control the robotic arm's four servo motors using on-screen joysticks for precise movements.
* **Bluetooth Connectivity:** Establishes a reliable connection with an Arduino robotic arm equipped with an HC-05 Bluetooth module.
* **Real-time Interaction:** Experience immediate feedback and control over your robotic arm's actions.
* **Specialized for 4 Servos:** Optimized for robotic arms with four servo motors, sending specific commands for each.
* **Cross-Platform Potential:** Built with Flutter, the app is designed for future expansion to other mobile platforms (currently Android-focused).

## Repository Usage (For Developers & Contributors)

This section provides general instructions for anyone looking to use, contribute to, or understand the codebase of the `roboarm_controller_app` repository.

### Prerequisites

Before you begin, ensure you have the following installed:

* **Flutter SDK:** Follow the official Flutter installation guide for your operating system: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
* **Android Studio / VS Code:** With Flutter and Dart plugins installed.
* **Git:** For cloning the repository.

### Cloning the Repository

To get a local copy of the project, open your terminal or command prompt and run:

```bash
git clone [https://github.com/your-username/roboarm_controller_app.git](https://github.com/your-username/roboarm_controller_app.git)
cd roboarm_controller_app
````

(Note: Replace `https://github.com/your-username/roboarm_controller_app.git` with the actual repository URL once it's hosted on GitHub.)

### Running the App Locally

#### Get Dependencies:

Navigate to the project directory and fetch the necessary Flutter packages:

```bash
flutter pub get
```

#### Connect a Device/Emulator:

Ensure you have an Android device connected via USB (with USB debugging enabled) or an Android emulator running. You can check connected devices with:

```bash
flutter devices
```

#### Run the App:

Execute the following command to build and run the app on your connected device or emulator:

```bash
flutter run
```

### Project Structure

The project follows a standard Flutter application structure. Key directories include:

  * `lib/`: Contains the Dart source code for the Flutter application.
  * `android/`: Android-specific configuration and native code.
  * `ios/`: iOS-specific configuration and native code (if applicable for future iOS development).
  * `pubspec.yaml`: Defines project dependencies and metadata.

### Contributing

We welcome contributions\! If you'd like to contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes and commit them (`git commit -m 'Add new feature'`).
4.  Push to the branch (`git push origin feature/your-feature-name`).
5.  Create a Pull Request.

Please ensure your code adheres to good practices and includes appropriate comments.

## Installing the Android App (For End-Users)

The RoboArm Controller app is currently available as an Android application package (APK). Follow these general steps to install it on your Android device.

**Important Security Note:** Installing APKs from outside the Google Play Store requires enabling "Install unknown apps" or "Unknown sources" on your device. Proceed with caution and only download apps from trusted sources.

### Download the APK:

Click on the following link to download the RoboArm Controller APK file:
[https://drive.google.com/file/d/1Y7jm0nrkpHhKs3q1XuqfyJplpvWwRqc5/view?usp=sharing](https://drive.google.com/file/d/1Y7jm0nrkpHhKs3q1XuqfyJplpvWwRqc5/view?usp=sharing)

(You might need to sign in to your Google account to access the file, depending on your Google Drive settings and permissions.)

### Enable Unknown Sources (if necessary):

If you haven't installed APKs from outside the Play Store before, your device will likely block the installation for security reasons. You'll need to enable "Install unknown apps" for your browser or file manager. The exact steps vary by Android version and device manufacturer:

  * **Android 8.0 (Oreo) and above:**

      * Go to `Settings > Apps & notifications > Special app access > Install unknown apps`.
      * Find the app you're using to open the APK (e.g., your browser like Chrome, or your file manager app).
      * Toggle on `Allow from this source`.

  * **Android 7.x (Nougat) and below:**

      * Go to `Settings > Security` (or `Lock screen and security`).
      * Toggle on `Unknown sources`.
      * Confirm the warning message.

### Install the APK:

Once the download is complete, open your device's `Files` or `Downloads` app.

  * Locate the downloaded APK file (it will likely be named something like `apk-release.apk`).
  * Tap on the APK file.
  * You will be prompted to install the application. Tap `Install`.

### Launch the App:

After the installation is complete, you can find the "RoboArm Controller" app icon in your app drawer and launch it.

## Connecting to Your Robotic Arm

Once the app is installed, you will need to:

1.  **Power On Your Robotic Arm:** Ensure your Arduino robotic arm with the HC-05 Bluetooth module is powered on and ready to pair.
2.  **Enable Bluetooth on Your Mobile Device:** Go to your phone's settings and turn on Bluetooth.
3.  **Pair with HC-05:** In your phone's Bluetooth settings, search for available devices and pair with your HC-05 module (it usually appears as "HC-05" or a similar name). You might be prompted for a PIN (common default PINs are `1234` or `0000`).
4.  **Connect via App:** Open the RoboArm Controller app. Inside the app, look for a button labeled "Available Devices" (or similar). Tapping this button will display a list of Bluetooth devices in the vicinity, including your paired HC-05 module. Select your HC-05 module from this list to establish the connection.

**Note for Arduino Developers:** The mobile application sends control commands as string values prefixed with `S1-`, `S2-`, `S3-`, and `S4-`. Your Arduino code should be configured to parse these incoming strings to extract the servo angle values for each of the four servo motors. For example, `S1-90` would indicate setting servo 1 to 90 degrees.

## Support

If you encounter any issues or have questions, please open an issue on this GitHub repository.

## Credits

  * **Organization:** OharaDev
  * **Developer:** jamir4270

**Disclaimer:** This application is provided as-is. Ensure proper safety measures when operating robotic arms. The developers are not responsible for any damage or injury caused by the use of this application or the robotic arm.

```
```