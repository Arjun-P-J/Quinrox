import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinrox/constants/decorations.dart';
import 'package:quinrox/models/user_auth.dart';
import 'package:quinrox/services/api/api_handler.dart';
import 'package:quinrox/services/register_on_device.dart';

import '../../models/device.dart';



















class Connections extends StatefulWidget {
  const Connections({Key? key}) : super(key: key);

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {

  AuthModule _authModule=AuthModule();
  DeviceStoredValues _storageDevice=DeviceStoredValues();


  int _selectIndex=0;

  @override
  Widget build(BuildContext context) {

    String email=Provider.of<UserAccount>(context).email ?? "";
    print("email is ${email}");
    return FutureBuilder(

        future: _authModule.hardwarePresentDevices(email, "TEST A"),
        builder: (context ,AsyncSnapshot snapshot){

          List<RegisteredDevices> devices = snapshot.data ?? [];
          print("data available ${devices}");
          return Center(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),

                    OutlinedButton(
                      child: Text("Add Device"),
                      onPressed: () async{

                            try {
                              RegisteredDevices deviceRegistred = await
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddDevice();
                                  });
                              if(deviceRegistred!=null){
                                String response=await _authModule.hardwareAuthReg(email, deviceRegistred.hardwareId, deviceRegistred.sensorName);
                                print("added ${response}");
                                setState(() {

                                });
                                print("device Registered ${deviceRegistred}");
                              }
                            }
                            catch(e){
                              print(e.toString());
                            }



                    },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.5,
                      width: MediaQuery.of(context).size.width*0.7,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          itemCount: devices.length ?? 0,
                          itemBuilder: (context,index){
                            return ListTile(
                              selectedColor: Colors.lightGreen,
                              onTap: () async{

                               String response=await showDialog(
                                    context: context,
                                    builder: (BuildContext context){

                                      return SelectDevice(hardwareId: devices[index].hardwareId, sensorName: devices[index].sensorName);
                                    });

                               if(response=="Remove Device"){
                                 _authModule.hardwareAuthRemove(email, devices[index].hardwareId);
                                 setState(() {
                                    int value=devices.length-1;
                                    if(value>=0){
                                      print("the value ${value}");
                                      Provider.of<UserDevice>(context,listen: false).switchDevice(devices[value].hardwareId, devices[value].sensorName);
                                      _selectIndex=value;
                                    }
                                    if(value==0) {
                                      Provider.of<UserDevice>(context, listen: false).switchDevice("No Device", "No Device");
                                      _storageDevice.deleteDeviceValues();
                                    }

                                 });
                               }
                               else{
                                 _storageDevice.storeData("deviceCurrent",devices[index].hardwareId);
                                 setState(() {
                                   Provider.of<UserDevice>(context,listen: false).switchDevice(devices[index].hardwareId, devices[index].sensorName);
                                   _selectIndex=index;
                                 });
                               }
                              },
                              title: Text("${devices[index].hardwareId}"),
                              subtitle: Text("${devices[index].sensorName}"),
                            );
                          }),
                    ),
                  ],
                ),
              ),
          );


      }
    );
  }
}



class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {

  final device=RegisteredDevices(hardwareId: "", sensorName: "");
  final _key=GlobalKey<FormState>();

  String error="";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width*0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val)=>val!.isEmpty?"Please enter a harware id":null,
                  onChanged: (val){
                    setState(() {
                      device.hardwareId=val;
                    });
                  },
                  decoration:decorationTextBox.copyWith(icon: Icon(Icons.devices),hintText: "hardware id"),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: (val)=>val!.isEmpty?"Please enter a sensor id":null,
                  onChanged: (val){
                    setState(() {
                      device.sensorName=val;
                    });
                  },
                  decoration:decorationTextBox.copyWith(icon: Icon(Icons.devices),hintText: "sensor id"),
                ),
                SizedBox(height: 20,),
                Text(error),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        child:Text("Add Device") ,
                        onPressed: (){
                          if(_key.currentState!.validate()) {
                            print("device data${device}");
                            Navigator.pop(context, device);
                          }
                          else {
                            setState(() {
                              error = "Please enter a valid data";
                            });
                          }
                    },),
                    ElevatedButton(
                      child:Text("Cancel") ,onPressed: (){
                      Navigator.pop(context,null);
                    },),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



class SelectDevice extends StatefulWidget {
  String hardwareId;
  String sensorName;
  
  SelectDevice({required this.hardwareId,required this.sensorName});
  
  @override
  State<SelectDevice> createState() => _SelectDeviceState();
}

class _SelectDeviceState extends State<SelectDevice> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height*0.3,
          width: MediaQuery.of(context).size.width*0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20,),
              Text("${widget.hardwareId}"),
              SizedBox(height: 20,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(child: Text("Select Device"),onPressed: (){
                      Navigator.pop(context,"Current Device");
                    },),
                    ElevatedButton(child: Text("Remove Device"),onPressed: (){
                      Navigator.pop(context,"Remove Device");
                    },)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
