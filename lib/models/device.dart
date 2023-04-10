import 'package:flutter/material.dart';




















class UserDevice extends ChangeNotifier{

  String deviceName="No Device";
  String sensorName="No sensor";
  ValueNotifier<String> deviceCurrent=ValueNotifier("No Device");

  void switchDevice(String deviceName,String sensorName){
    this.deviceName=deviceName;
    this.sensorName=sensorName;
    print("${this.deviceName} ${this.sensorName}");
    deviceCurrent.value=deviceName;
    notifyListeners();

  }
}

class RegisteredDevices {

  String hardwareId;
  String sensorName;

  RegisteredDevices({required this.hardwareId,required this.sensorName});


}

