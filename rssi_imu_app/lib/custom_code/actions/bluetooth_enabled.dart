// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ignore_for_file: deprecated_member_use

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<bool> bluetoothEnabled() async {
  await FlutterBluePlus.instance.isOn;
  await Future.delayed(Duration(milliseconds: 100));
  final state = await FlutterBluePlus.instance.state.first;
  if (state == BluetoothState.on) {
    return true;
  }
  return false;
}
