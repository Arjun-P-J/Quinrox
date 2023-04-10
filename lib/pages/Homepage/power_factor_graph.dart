import 'package:flutter/material.dart';
import "package:quinrox/RealtimeUpdates/bloc_architecture/fetch_handler.dart";

















class GraphPlotPowerFactor extends StatefulWidget {
  const GraphPlotPowerFactor({Key? key}) : super(key: key);

  @override
  State<GraphPlotPowerFactor> createState() => _GraphPlotPowerFactorState();
}

class _GraphPlotPowerFactorState extends State<GraphPlotPowerFactor> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FetchApiHandlerPowerFactor(xLabel: "hour_start",
        yLabel: "avg_voltage_value",
        backgroundColor: Color(0xff282828),
        pallete: [Colors.green],
        graphType: "LineGraph",
        legendWidget: Text("Hi"),
        axis: false,),
    );
  }
}

