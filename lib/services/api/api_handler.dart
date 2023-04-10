import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:quinrox/models/device.dart";
import "package:quinrox/models/graphs_and_dataset.dart";

import "";

















//class to handle Authorization
class AuthModule{

  Dio _dio=Dio();

  //registers authorization with server
  Future authReg(String first_name,String last_name,String email,String industry_name) async {
    try {
      await _dio.post(
            "http://3.141.1.241:5080/authReg",
            data: {
              "dummy": "123",
              "first_name": first_name,
              "last_name": last_name,
              "e_mail": email,
              "idustry_name": industry_name,
            }
          );
    }
    catch(e){
      print(e.toString());
    }
  }

  //registers a harware device to server and provides a registration id
  Future<String> hardwareAuthReg(String email,String hardwareId,String sensorName) async{
      try{
       return await _dio
           .post(
              "http://3.141.1.241:5080/hwRgFU",
                data: {
                  "dummy":"123",
                  "e_mail":email,
                  "hardware_id":hardwareId,
                  "sensor_name":sensorName,
                }
           )
           .then((value) {
             print("value data ${value.data}");
             return value.data;
           });
      }
      catch(e){
          return "${e} Device not registered";
      }
  }

  //removes a device from the server
 Future<String> hardwareAuthRemove(String email,String hardwareId) async{
    try{
      return await _dio
          .post(
            "http://3.141.1.241:5080/hwRm",data: {
              "dummy":"123",
              "email":email,
              "hardware_id":hardwareId,
            }
          )
          .then((value) => value.data);
    }
    catch(e){
          return "Device not removed";
    }
 }

 //the list of device added
 Future<List<RegisteredDevices>> hardwarePresentDevices(String email,String sensorName) async{
    try{
      print("harware now access");
      return await _dio
          .post(
              "http://3.141.1.241:5080/hwConnect",
              data: {
                "e_mail":email,
                "sensor_name":sensorName,
              }
          )
          .then((value)  {
            print("value json ${jsonEncode(value.data)}");
            return value.data.map<RegisteredDevices>((device){
            print("data being sent ${device["hardware_id"]}");
            return RegisteredDevices(hardwareId: device["hardware_id"], sensorName: device["sensor_name"]);
      }).toList();
          });
    }
    catch(e){
        print(e.toString());
        return [];
    }
 }


}

class DataModule{

  Dio _dio=Dio();

  String device;
  DataModule({required this.device});

  var provider_id=jsonEncode({
    "provider_id":"KSEB",
  });

  //to get day dashboard values
  Future<List<String>> getDashboardDay() async{
      try {
          List response = await Future.wait([
            _dio.get("http://3.141.1.241:5080/dayPower/$device/1"),
            _dio.get("http://3.141.1.241:5080/dayUnit/$device/1"),
            _dio.post("http://3.141.1.241:5080/dayBill/$device/1",
              data: provider_id,
              options: Options(headers: {HttpHeaders.contentTypeHeader:"application/json"}),
            ),
          ]
          );

          //if there is no response
          if(response!=null) {
            print("response is ${response[0].data[1]["avg_value"]} ${response[1]
                .data["value"]} ${response[2].data["value"]}");
            return [
              response[0].data[1]["avg_value"].toStringAsFixed(3)+" Watt",
              response[1].data["value"].toStringAsFixed(3)+" Units",
              response[2].data["value"].toStringAsFixed(3)+" INR",
            ];
          }
          else{
            return ["0 Watt","0 Units","0 INR"];
          }
      }
      catch(e){
        print(e.toString());
        return[];
      }
  }

  //to get dashboard month values
  Future<List<String>> getDashboardMonth() async{
    try {
      List response = await Future.wait([
        _dio.get("http://3.141.1.241:5080/monthPower/$device/1"),
        _dio.get("http://3.141.1.241:5080/monthUnit/$device/1"),
        _dio.post("http://3.141.1.241:5080/monthBill/$device/1",
          data:provider_id,
          options: Options(headers: {HttpHeaders.contentTypeHeader:"application/json"})
        ),
      ]
      );
      if(response!=null) {
        print("response is $response");
        return [
          response[0].data[0]["avg_value"].toStringAsFixed(3)+" Watt",
          response[1].data["value"].toStringAsFixed(3)+" Units",
          response[2].data["value"].toStringAsFixed(3)+" INR",
        ];
      }
      else{
        return ["0 Watt","0 Units","0 INR"];
      }
    }
    catch(e){
      print(e.toString());
      return [];
    }
  }

  //to get power graph
  Future<List<PlotPoints>> getPowerGraph(String durationType,int duration) async{
    try{

        dynamic response=await _dio.get("http://3.141.1.241:5080/${durationType}Power/$device/${duration}");
          return response?.data.map<PlotPoints>((value) =>
              PlotPoints(xValue: value["${durationType}_start"],
                  yValue: value["avg_value"])).toList();


    }
    catch(e){
      print(e.toString());
      return [];
    }
  }

  //to get vi graph
  Future<List<PlotPoints>> getVIGraph(String graph) async{
    try{
        dynamic response=await _dio.get("http://3.141.1.241:5080/viTriger/$device/15");
        print("The response is $response");

        return response.data.map<PlotPoints>((value)=>PlotPoints(xValue: value["hour_start"],yValue: value["avg_${graph}_value"])).toList();
    }
    catch(e){
      print(e.toString());
      return [];
    }
  }

  Future<double> getPower(String durationType,int duration) async{
    try{
      dynamic response=await _dio.get("http://3.141.1.241:5080/${durationType}Power/${device}/${duration}");
      double sum=0.0;
      for(int i=0;i<response.data.length;i++){
        sum=sum+response.data[i]["avg_value"];
      }

      return response!.data.length==0?sum:(sum/response.data.length);
    }
    catch(e){
      print(e.toString());
      return 0.0;
    }
  }

  Future<double> getUnitConsumptionData(String durationType,String duration) async{
    try{
      print("the url is http://3.141.1.241:5080/${durationType}Unit/${device}/${duration}");
      dynamic response=await _dio.get("http://3.141.1.241:5080/${durationType}Unit/${device}/${duration}");
      print("response value $response");
      return response!.data["value"];
    }
    catch(e){
      print(e.toString());
      return 0.0;
    }
  }


  Future<double> getPowerUsageBill(String durationType,String duration) async{
    try{
      dynamic response=await _dio.post("http://3.141.1.241:5080/${durationType}Bill/$device/$duration",
      data: provider_id,
      );
      print("the response of a unit is $response");
      return response!.data["value"];
    }
    catch(e){
      print(e.toString());
      return 0.0;
    }
  }

  Future<List<PlotPoints>> getPowerFactor() async{

    try{
      dynamic response=await _dio.get("http://3.141.1.241:5080/viTriger/$device/15");
      return response?.data.map<PlotPoints>((value)=>PlotPoints(xValue: value["hour_start"], yValue: value["avg_pf_value"])).toList();
    }
    catch(e){
        print(e.toString());
        return [];
    }

  }

}
