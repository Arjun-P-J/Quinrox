import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quinrox/models/device.dart';
import 'package:quinrox/models/user_auth.dart';
import 'package:quinrox/pages/Homepage/connections.dart';
import 'package:quinrox/pages/Homepage/dashboard.dart';
import 'package:quinrox/pages/Homepage/power_factor_graph.dart';
import 'package:quinrox/pages/Homepage/vi_graph_plot.dart';
import 'package:quinrox/services/register_on_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Authentication/authentication.dart';


















class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context)=>UserDevice(),
        builder: (context,child)=>BaseLayout(),
    );
  }
}

class BaseLayout extends StatefulWidget {
  const BaseLayout({Key? key}) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  Authenticate _auth=Authenticate();

  DeviceStoredValues _storageDevice=DeviceStoredValues();

  List<String> userAccountActions=["Profile","Exit"];

  int index=0;

  List<Widget> _page=[Dashboard(),GraphPlotVI(),GraphPlotPowerFactor(),Connections()];

  //load evice selected previously
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    initializeDevice().whenComplete(() {
     setState(() {

     });
    });
  }

  void initialize() async{
    Future.delayed(Duration(seconds: 2),(){
      FlutterNativeSplash.remove();
    });
  }

  Future<void>  initializeDevice() async{
    SharedPreferences _prefs=await _storageDevice.accessDeviceValues();
    String? hardwareId=await _prefs.getString("deviceCurrent");
    print("the device is $hardwareId");
    Future.delayed(Duration(seconds: 5),(){
      print("hardware id $hardwareId");
      Provider.of<UserDevice>(context,listen: false).switchDevice(hardwareId ?? "No Device","TEST A");
    });

  }


  @override
  Widget build(BuildContext context) {
    String _deviceName=Provider.of<UserDevice>(context).deviceName;
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color(0xff282828),
        title: Text("Spectrum"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext context){
                  return List.generate(userAccountActions.length, (index) {
                    return PopupMenuItem(
                      child: Text("${userAccountActions[index]}"),
                      onTap: () async{
                        print("value $index");
                        if(index==userAccountActions.length-1){
                          await _auth.signOut();
                        }
                      },
                    );
                  });
              },

          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: Consumer<UserDevice>(
            builder: (context,index,child)=>Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  if(_deviceName=="No Device") ...[
                    Icon(Icons.device_unknown, color: Colors.redAccent,)
                  ]
                  else...[
                    Icon(Icons.devices,color: Colors.lightGreen,),
                  ],
                  SizedBox(width: 20,),
                  Text("${_deviceName}", style: TextStyle(color: Colors.white),),
                  SizedBox(width: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
      body:Consumer<UserDevice>(
         builder: (context,deviecSelected,child){
           print("widgte restatered");
           return _page[index] ;
         }
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (val) {
          setState(() {
            index = val;
          });
        },
        type: BottomNavigationBarType.shifting,
        fixedColor: Colors.green,
        items:const [
          BottomNavigationBarItem(
              label: "homepage",
              icon: Icon(Icons.home),
              backgroundColor: Color(0xff282828)
          ),
          BottomNavigationBarItem(
            label: "Voltage Current",
            icon: Icon(Icons.auto_graph),
            backgroundColor: Color(0xff282828),
          ),
          BottomNavigationBarItem(
            label: "Power Factor",
            icon: Icon(Icons.bar_chart),
            backgroundColor: Color(0xff282828),
          ),
          BottomNavigationBarItem(
              label: "Connections",
              icon: Icon(Icons.wifi),
              backgroundColor: Color(0xff282828)
          ),
        ],
      ),
    );
  }
}
