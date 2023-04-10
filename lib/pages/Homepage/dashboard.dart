import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetch_handler.dart';
import 'package:quinrox/models/device.dart';
import 'package:quinrox/pages/Homepage/power_factor_graph.dart';



















class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Today",style: TextStyle(color: Colors.black,fontSize: 20),))),
          SizedBox(height: 20,),
          FetchApiHandlerDashboardDay(),
          SizedBox(height: 20,),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Month",style: TextStyle(color: Colors.black,fontSize: 20),))),
          SizedBox(height: 20,),
          FetchApiDashboardMonth(),
          SizedBox(height: 20,),
          FetchApiHandlerPowerMonitor(
            device: Provider.of<UserDevice>(context).deviceName,
              xLabel: "month_start",
              yLabel: "avg_value",
              graphType: "Bar Graph",
              backgroundColor: Colors.white,
              pallete: [Color.fromRGBO(67, 179, 174, 1)],
              legendWidget: ElevatedButton(
                child: Text("Change Values"),
                onPressed: () {},
              ),
              axis: true,
          ),


          SizedBox(height: 20,),
          FetchApiUnitData(),
          SizedBox(height: 20,),
          FetchApiPowerValues(),
          SizedBox(height: 20,),

        ],
      ),
    );
  }
}





