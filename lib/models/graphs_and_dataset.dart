


















class PlotPoints{
  String xValue;
  double yValue;
  PlotPoints({required this.xValue,required this.yValue});
}

class DashboardData{
  String power;
  String data;
  String powerBill;
  DashboardData({required this.power,required this.data,required this.powerBill});
}

class GraphPowerMonitorValues{
  String valueType;
  int value;
  GraphPowerMonitorValues({required this.valueType,required this.value});
}

class PowerSet{
  List<PlotPoints> plotPoints;
  double powerValue;
  PowerSet({required this.plotPoints,required this.powerValue});
}