import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetch_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/graphs_and_dataset.dart';

















class PlotSet extends StatefulWidget {

  List<PlotPoints> plotPoints;
  Color backgroundColor;
  List<Color> pallete;
  Widget legendWidget;
  bool axis;
  String graphType;
  PlotSet({required this.plotPoints,required this.backgroundColor,required this.pallete,required this.legendWidget,required this.axis,required this.graphType});

  @override
  State<PlotSet> createState() => _PlotSetState();
}

class _PlotSetState extends State<PlotSet> {

  GraphPowerMonitorValues _currentValue=GraphPowerMonitorValues(valueType: "hour", value: 1);
  String _graphVIValue="voltage";

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      backgroundColor: widget.backgroundColor,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      legend: Legend(
          isVisible:true,
          toggleSeriesVisibility: false,
          position: LegendPosition.top,
          isResponsive: true,
          legendItemBuilder: (name,series,point,index) {
             if (widget.graphType == "LineGraph") {
               return DropdownButton(
                 hint: Text("$_graphVIValue",style: TextStyle(color: Colors.white),),
                 dropdownColor: Colors.white,
                   items: [
                     DropdownMenuItem(
                       child: Text("voltage"),
                       value: "voltage",
                     ),
                     DropdownMenuItem(
                       child: Text("current"),
                       value:"current",
                     ),
                   ],
                   onChanged: (val){
                      context.read<FetchCubitVIGraph>().fetchData(val ?? "voltage");
                      setState(() {
                        _graphVIValue=val ?? "voltage";
                      });
               });
             }
            else {
              return OutlinedButton(onPressed: () async {
                dynamic value = await showModalBottomSheet(
                    context: context, builder: (BuildContext context) {
                  return GraphPowerMonitor();
                });
                if (value != null) {
                  setState(() {
                    _currentValue = value;
                    print("the data to be fetched is ${_currentValue
                        .valueType} ${_currentValue.value}");
                  });
                  context.read<FetchCubitPowerMonitorGraph>().fetchData(
                      _currentValue.valueType, _currentValue.value);
                }
              }, child: Text("Options"));
            }
          }
      ),
      isTransposed: widget.axis,
      palette: widget.pallete,
      series: <ChartSeries<PlotPoints,String>>[
        if(widget.graphType=="LineGraph")...[
          SplineSeries(dataSource: widget.plotPoints, xValueMapper: (PlotPoints _plotPoints,_)=>_plotPoints.xValue, yValueMapper: (PlotPoints _plotPoints,_)=>_plotPoints.yValue.toDouble())
        ]
        else...[
          BarSeries(dataSource: widget.plotPoints, xValueMapper: (PlotPoints _plotPoints,_){
            print("plt x${_plotPoints.xValue} plt y ${_plotPoints.yValue}");
            return _plotPoints.xValue;}, yValueMapper: (PlotPoints _plotPoints,_)=>_plotPoints.yValue.toInt()),
        ]

      ],
    );
  }
}





class GraphPowerMonitor extends StatefulWidget {
  const GraphPowerMonitor({Key? key}) : super(key: key);

  @override
  State<GraphPowerMonitor> createState() => _GraphPowerMonitorState();
}

class _GraphPowerMonitorState extends State<GraphPowerMonitor> {
  GraphPowerMonitorValues graphValues=GraphPowerMonitorValues(valueType: "", value: 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton(
                  hint: Text("Hour"),
                  items:[
                DropdownMenuItem(
                  child: Text("1"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("3"),
                  value: 3,
                ),
                DropdownMenuItem(
                  child: Text("5"),
                  value: 5,
                ),
                DropdownMenuItem(
                  child: Text("7"),
                  value: 7,
                ),
              ],
                  onChanged: (val){
                            graphValues.valueType="hour";
                            graphValues.value=val ?? 1;
                  }),
              DropdownButton(
                hint: Text("Day"),
                  items: [
                DropdownMenuItem(
                    child: Text("1"),
                    value:1
                ),
                DropdownMenuItem(
                    child: Text("5"),
                    value:5
                ),
                DropdownMenuItem(
                    child: Text("7"),
                    value:7
                ),
              ], onChanged: (val){
                    graphValues.valueType="day";
                    graphValues.value=val ?? 1;
              }),
              DropdownButton(
                hint: Text("Month"),
                  items: [
                DropdownMenuItem(
                    child: Text("1"),
                    value:1
                ),
                    DropdownMenuItem(
                        child: Text("2"),
                        value:2
                    ),
              ],
                  onChanged: (val){
                  graphValues.valueType="month";
                  graphValues.value=val ?? 1;
              }),
            ],
          ),
          OutlinedButton(onPressed: (){
            Navigator.pop(context,graphValues);
          }, child: Text("Ok"))
        ],
      ),
    );
  }
}

