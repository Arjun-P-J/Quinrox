import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quinrox/Graph/syncfusion_graph.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetchStates.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetch_cubit.dart';
import 'package:quinrox/models/device.dart';
import 'package:quinrox/pages/Homepage/dashboard.dart';


















class FetchApiHandlerPowerMonitor extends StatefulWidget {

  String device;
  String xLabel;
  String yLabel;

  String graphType;
  Color backgroundColor;
  List<Color> pallete;
  Widget legendWidget;
  bool axis;

  FetchApiHandlerPowerMonitor({required this.device,required this.xLabel,required this.yLabel,required this.graphType,required this.backgroundColor,required this.pallete,required this.legendWidget,required this.axis});

  @override
  State<FetchApiHandlerPowerMonitor> createState() => _FetchApiHandlerPowerMonitorState();
}

class _FetchApiHandlerPowerMonitorState extends State<FetchApiHandlerPowerMonitor> {



  @override
  Widget build(BuildContext context) {

    String device=Provider.of<UserDevice>(context).deviceName;
    FetchCubitPowerMonitorGraph state=FetchCubitPowerMonitorGraph(deviceName: device, xLabel: widget.xLabel,yLabel: widget.yLabel);
    return Consumer<UserDevice>(
        builder:(context,currentDevice,child){
          print("${currentDevice.deviceName}");
          return BlocProvider(
            create: (BuildContext context)=>state,
            child: BlocBuilder<FetchCubitPowerMonitorGraph,FetchState>(
              bloc: state,
              builder: (context,state){

                if(state is FetchStateLoading){
                  return CircularProgressIndicator();
                }

                if(state is FetchStateLoadedPowerMonitorGraph){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PlotSet(plotPoints: state.powerSet.plotPoints, backgroundColor: widget.backgroundColor, pallete: widget.pallete, legendWidget: widget.legendWidget, axis: widget.axis, graphType: widget.graphType),
                      SizedBox(height: 20,),
                      Align(
                          alignment: Alignment.centerRight,
                          child:Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child:Text("${state.powerSet.powerValue.toStringAsFixed(3)} Watt"))),
                    ],
                  );
                }

                return Center(
                  child: Text("Data cannot be loaded"),
                );
              },
            ),
          );
        }
    );
  }
}


class FetchApiHandlerVI extends StatefulWidget {
  String xLabel;
  String yLabel;

  String graphType;
  Color backgroundColor;
  List<Color> pallete;
  Widget legendWidget;
  bool axis;

  FetchApiHandlerVI({required this.xLabel,required this.yLabel,required this.graphType,required this.backgroundColor,required this.pallete,required this.legendWidget,required this.axis});

  @override
  State<FetchApiHandlerVI> createState() => _FetchApiHandlerVIState();
}

class _FetchApiHandlerVIState extends State<FetchApiHandlerVI> {
  @override
  Widget build(BuildContext context) {
    String device=Provider.of<UserDevice>(context).deviceName;
    FetchCubitVIGraph state=FetchCubitVIGraph(deviceName: device, xLabel: widget.xLabel,yLabel: widget.yLabel);
    return BlocProvider(
      create: (context)=>state,
      child: BlocBuilder<FetchCubitVIGraph,FetchState>(
        bloc: state,
        builder: (context,state){
          if(state is FetchStateLoading){
            return CircularProgressIndicator();
          }
          if(state is FetchStateLoadedGraphVI){
            return PlotSet(plotPoints: state.plotPoints, backgroundColor: widget.backgroundColor, pallete: widget.pallete, legendWidget: widget.legendWidget, axis: widget.axis, graphType: widget.graphType);
          }

          return Center(
            child: Text("Data cannot be loaded"),
          );
        },
      ),
    );
  }
}










class FetchApiHandlerDashboardDay extends StatefulWidget {
  const FetchApiHandlerDashboardDay({Key? key}) : super(key: key);

  @override
  State<FetchApiHandlerDashboardDay> createState() => _FetchApiHandlerDashboardDayState();
}

class _FetchApiHandlerDashboardDayState extends State<FetchApiHandlerDashboardDay> {

  @override
  Widget build(BuildContext context) {


    String deviceName=Provider.of<UserDevice>(context).deviceName;
    FetchCubitDashboardDay state=FetchCubitDashboardDay(device: deviceName);
    return BlocProvider(
      create:(context)=> state,
      child: BlocBuilder<FetchCubitDashboardDay,FetchState>(
        bloc: state,
        builder: (context,state){
          if(state is FetchStateLoading){
            return CircularProgressIndicator();
          }
          if(state is FetchStateLoadedDashboard){

              return DashboardDay(powerData: state.dashboardData);
          }

          return Text("Error occured during data fetch");
        },
      ),

    );
  }
}

class DashboardDay extends StatefulWidget {
  List<String> powerData;
  DashboardDay({required this.powerData});

  @override
  State<DashboardDay> createState() => _DashboardDayState();
}

class _DashboardDayState extends State<DashboardDay> {

  @override
  Widget build(BuildContext context) {
    return  Consumer<UserDevice>(
      builder:(context,selectedDevice,child){

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width:double.infinity,
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.powerData.length,
                itemBuilder: (context,index){
                  return Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.29,
                      child: Center(
                          child: Text("${widget.powerData[index]}")
                      ),
                    ),
                  );
                }
            )
        );
      }


    );

  }
}


class FetchApiDashboardMonth extends StatefulWidget {
  const FetchApiDashboardMonth({Key? key}) : super(key: key);

  @override
  State<FetchApiDashboardMonth> createState() => _FetchApiDashboardMonthState();
}

class _FetchApiDashboardMonthState extends State<FetchApiDashboardMonth> {
  @override
  Widget build(BuildContext context) {
    String deviceName=Provider.of<UserDevice>(context).deviceName;
    FetchCubitDashboardMonth state=FetchCubitDashboardMonth(device: deviceName);
    return BlocProvider(create: (context)=>state,
      child: BlocBuilder<FetchCubitDashboardMonth,FetchState>(
        bloc: state,
        builder: (context,state){
          if(state is FetchStateLoading){
            return CircularProgressIndicator();
          }

          if(state is FetchStateLoadedDashboard){
            return DashboardMonth(powerData: state.dashboardData,);
          }

          return Text("Error data is not available");
        },
      ),
    );
  }
}


class DashboardMonth extends StatefulWidget {
  List<String> powerData;
  DashboardMonth({required this.powerData});

  @override
  State<DashboardMonth> createState() => _DashboardMonthState();
}

class _DashboardMonthState extends State<DashboardMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width:double.infinity,
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context,index){
              return Card(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.29,
                  child: Center(
                      child: Text("${widget.powerData[index]}")
                  ),
                ),
              );
            }
        )
    );
  }
}

class FetchApiPowerValues extends StatefulWidget {
  const FetchApiPowerValues({Key? key}) : super(key: key);

  @override
  State<FetchApiPowerValues> createState() => _FetchApiPowerValuesState();
}

class _FetchApiPowerValuesState extends State<FetchApiPowerValues> {

  @override
  Widget build(BuildContext context) {

    String deviceName=Provider.of<UserDevice>(context).deviceName;

    FetchCubitPowerValue state=FetchCubitPowerValue(device: deviceName);

    return BlocProvider(create: (context)=>state,

        child: BlocBuilder<FetchCubitPowerValue,FetchState>(
          bloc: state,
          builder: (context,state){
            if(state is FetchStateLoading){
              return CircularProgressIndicator();
            }

            if(state is FetchStateValuesLoaded){
              print("state value is ${state.value}");
              return PowerUnit(value: state.value,dataType: "Power",);
            }

            return Text("Error in data");
          },
        )

    );
  }
}

class FetchApiUnitData extends StatefulWidget {
  const FetchApiUnitData({Key? key}) : super(key: key);

  @override
  State<FetchApiUnitData> createState() => _FetchApiUnitDataState();
}

class _FetchApiUnitDataState extends State<FetchApiUnitData> {


  @override
  Widget build(BuildContext context) {
    String deviceName=Provider.of<UserDevice>(context).deviceName;

    FetchCubitUnitValue state=FetchCubitUnitValue(device: deviceName);

    return BlocProvider(create: (context)=>state,

        child: BlocBuilder<FetchCubitUnitValue,FetchState>(
          bloc: state,
          builder: (context,state){
            if(state is FetchStateLoading){
              return CircularProgressIndicator();
            }

            if(state is FetchStateValuesLoaded){
              print("state value is ${state.value}");
              return PowerUnit(value: state.value,dataType: "Unit",);
            }

            return Text("Error in data");
          },
        )

    );
  }
}




class PowerUnit extends StatefulWidget {
  double value;
  String dataType;
  PowerUnit({required this.value,required this.dataType});

  @override
  State<PowerUnit> createState() => _PowerUnitState();
}

class _PowerUnitState extends State<PowerUnit> {
  String valueType="";
  String value="";

  void switchValue(String durationType,String duration){

    if(widget.dataType=="Unit"){
      context.read<FetchCubitUnitValue>().fetchDataValues(durationType, duration);
    }
    else{
      context.read<FetchCubitPowerValue>().fetchDataValues(durationType, duration);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black12,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      height:MediaQuery.of(context).size.height*0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton(
                hint: Text("Hour"),
                  items: [
                    DropdownMenuItem(child: Text("1"),value: 1,),
                    DropdownMenuItem(child: Text("3"),value: 3,),
                    DropdownMenuItem(child: Text("5"),value: 5,),
                    DropdownMenuItem(child: Text("7"),value: 7,),
                  ],
                  onChanged: (val){
                    switchValue("hour", val.toString());
                  }
              ),
              DropdownButton(
                hint: Text("Day"),
                  items: [
                    DropdownMenuItem(child: Text("1"),value: 1,),
                    DropdownMenuItem(child: Text("3"),value: 3,),
                    DropdownMenuItem(child: Text("5"),value: 5,),
                  ],
                  onChanged: (val){
                  switchValue("day", val.toString());
                  }
              ),
              DropdownButton(
                hint: Text("Month"),
                  items: [
                    DropdownMenuItem(child: Text("1"),value: 1,),
                    DropdownMenuItem(child: Text("2"),value: 2,),
                  ],
                  onChanged: (val){
                   switchValue("month", val.toString());
                  }
              ),
            ],
          ),
          if(widget.dataType=="Unit")
          ...[
            Text("Avg Unit consumption is  ${widget.value.toStringAsFixed(3)} Units")
          ]
          else
            ...[
              Text("Avg power bill is  ${widget.value.toStringAsFixed(3)} INR")
            ]
        ],
      ),
    );
  }
}


class FetchApiHandlerPowerFactor extends StatefulWidget {

  String xLabel;
  String yLabel;

  String graphType;
  Color backgroundColor;
  List<Color> pallete;
  Widget legendWidget;
  bool axis;

  FetchApiHandlerPowerFactor({required this.xLabel,required this.yLabel,required this.graphType,required this.backgroundColor,required this.pallete,required this.legendWidget,required this.axis});

  @override
  State<FetchApiHandlerPowerFactor> createState() => _FetchApiHandlerPowerFactorState();
}

class _FetchApiHandlerPowerFactorState extends State<FetchApiHandlerPowerFactor> {
  @override
  Widget build(BuildContext context) {
    String deviceName=Provider.of<UserDevice>(context).deviceName;

    FetchCubitPowerFactor state=FetchCubitPowerFactor(device: deviceName);

    return BlocProvider(create: (context)=>state,
      child: BlocBuilder<FetchCubitPowerFactor,FetchState>(
        bloc: state,
        builder: (context,state){
          if(state is FetchStateLoading){
            return CircularProgressIndicator();
          }
          if(state is FetchStatePowerFactor){
            return PlotSet(plotPoints: state.plotPoints, backgroundColor: widget.backgroundColor, pallete: widget.pallete, legendWidget: widget.legendWidget, axis: widget.axis, graphType: widget.graphType);
          }
          return Text("Error in data");
        },
      ),

    );
  }
}

