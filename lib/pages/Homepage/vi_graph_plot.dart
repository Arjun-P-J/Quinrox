import 'package:flutter/material.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetch_handler.dart';

















class GraphPlotVI extends StatefulWidget {
  const GraphPlotVI({Key? key}) : super(key: key);

  @override
  State<GraphPlotVI> createState() => _GraphPlotVIState();
}

class _GraphPlotVIState extends State<GraphPlotVI> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FetchApiHandlerVI(
        xLabel: "hour_start",
        yLabel: "avg_voltage_value",
        backgroundColor: Color(0xff282828),
        pallete: [Colors.green],
        graphType: "LineGraph",
        legendWidget: Text("Hi"),
        axis: false,
      ),
    );
  }
}
