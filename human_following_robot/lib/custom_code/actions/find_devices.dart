// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<List<BTDevicesStruct>> findDevices() async {
  BTDevicesStruct temp_device =
      new BTDevicesStruct(name: "test", id: "test1", rssi: 100);

  List<BTDevicesStruct> devices = [];
  devices.add(temp_device);
  FlutterBluePlus.scanResults.listen((results) {
    List<ScanResult> scannedDevices = [];
    for (ScanResult r in results) {
      if (r.device.platformName.isNotEmpty) {
        scannedDevices.add(r);
      }
    }
    scannedDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
    devices.clear();
    scannedDevices.forEach((deviceResult) {
      devices.add(BTDevicesStruct(
        name: deviceResult.device.platformName,
        id: deviceResult.device.remoteId.toString(),
        rssi: deviceResult.rssi,
      ));
    });
  });
  final isScanning = FlutterBluePlus.isScanningNow;
  if (!isScanning) {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );
  }

  return devices;
}

/*
Future<List<BTDevicesStruct>> findDevices() async {
  List<BTDevicesStruct> devices = [];
  FlutterBluePlus.scanResults.listen((results) {
    List<ScanResult> scannedDevices = [];
    for (ScanResult r in results) {
      if (r.device.platformName.isNotEmpty) {
        scannedDevices.add(r);
      }
    }
    scannedDevices.sort((a, b) => b.rssi.compareTo(a.rssi));
    devices.clear();
    scannedDevices.forEach((deviceResult) {
      devices.add(BTDevicesStruct(
        name: deviceResult.device.platformName,
        id: deviceResult.device.remoteId.toString(),
        rssi: deviceResult.rssi,
      ));
    });
  });
  final isScanning = FlutterBluePlus.isScanningNow;
  if (!isScanning) {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );
  }

  BTDevicesStruct temp_device = BTDevicesStruct(name: "test", id: "test1", rssi: 100);
  devices.add(temp_device);
  return devices;

  List<ScanResult> bluetoothDevices = [];
  //Stop scan before restarting scan too prevent errors when trying to scan
  await FlutterBluePlus.stopScan();
  print("Start scan");
  // Start scanning
  List<dynamic> foundDevices = await FlutterBluePlus.startScan(
    timeout: const Duration(
      seconds: 10,
    ),
  ).asStream().toList();
  await FlutterBluePlus.stopScan();
  for(dynamic devices in foundDevices){
    for(ScanResult device in devices){
      bluetoothDevices.add(device);
    }
  }
  List<BTDevicesStruct> retDevices = [];
  for (ScanResult result in bluetoothDevices){
    retDevices.add(BTDevicesStruct(
      name: result.device.platformName,
      id: result.device.remoteId.toString(),
      rssi: result.rssi
    ));
  }
  BTDevicesStruct tempDevice = BTDevicesStruct(name: "test", id: "test1", rssi: 100);
  retDevices.add(tempDevice);
  return retDevices;

  var subscription = FlutterBluePlus.onScanResults.listen((results) {
    if (results.isNotEmpty) {
      ScanResult r = results.last; // the most recently found device
      print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
    }
  },
      onError(e) => print(e);
  );

// Wait for Bluetooth enabled & permission granted
// In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
  await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

// Start scanning
    //FlutterBluePlus.startScan(timeout: const Duration(seconds: 1));
    //FlutterBluePlus.stopScan();
    //Timer(Duration(seconds: 1), () {
      //FlutterBluePlus.startScan(timeout: const Duration(seconds: 1))
    //});
// Stop scanning
    await FlutterBluePlus.stopScan();

// cancel to prevent duplicate listeners
    subscription.cancel();

    List<BTDevicesStruct> devices = [];
    BTDevicesStruct tempDevice = BTDevicesStruct(name: "test", id: "test1", rssi: 100);
    devices.add(tempDevice);
    return devices;
}
*/
