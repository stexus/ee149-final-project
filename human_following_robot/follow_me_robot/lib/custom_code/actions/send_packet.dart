// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';

Future sendPacket(BTDevicesStruct deviceInfo) async {
  final sensor = Sensors();
  sensor.magnetometerEvents.listen((MagnetometerEvent event) {
    String packet = deviceInfo.rssi.toString() +
        "," +
        event.x.toString() +
        "," +
        event.y.toString() +
        "," +
        event.z.toString();
    sendData(deviceInfo, packet);
  });
}
