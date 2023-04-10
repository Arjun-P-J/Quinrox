import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quinrox/RealtimeUpdates/bloc_architecture/fetchStates.dart';

import '../../models/graphs_and_dataset.dart';
import '../../services/api/api_handler.dart';
import '../../services/register_on_device.dart';

















class FetchCubitPowerMonitorGraph extends Cubit<FetchState>{

  String deviceName;
  String xLabel;
  String yLabel;
  DataModule? _dataModule;
  FetchCubitPowerMonitorGraph({required this.deviceName,required this.xLabel,required this.yLabel}):super(
      FetchStateLoadedPowerMonitorGraph(powerSet: PowerSet(plotPoints: [], powerValue: 0))

  ){
    print(" the constructor is running somewhere");
    _dataModule=DataModule(device:deviceName);
    fetchData("hour",1);
  }



  void fetchData(String durationType,int duration) async{
    try{

      List<PlotPoints>? _plotPoints=await _dataModule?.getPowerGraph(durationType,duration);
      double? _dataValue=await _dataModule?.getPower(durationType, duration);


      if(_plotPoints!=null && _dataValue!=null) {
        print("values are printed now $_plotPoints ");
        emit(state.copyWith(PowerSet(plotPoints: _plotPoints, powerValue: _dataValue)));
      }
    }
    catch(e){
      print("the error is $e");
      emit(FetchStateError(error: "$e"));
    }
  }

}

class FetchCubitVIGraph extends Cubit<FetchState>{

  String deviceName;
  String xLabel;
  String yLabel;
  DataModule? _dataModule;
  FetchCubitVIGraph({required this.deviceName,required this.xLabel,required this.yLabel}):super(
      FetchStateLoadedGraphVI(plotPoints: [])){

    _dataModule=DataModule(device:deviceName);
    fetchData("voltage");
  }



  void fetchData(String plot) async{
    try{

      List<PlotPoints>? _plotPoints=await _dataModule?.getVIGraph(plot);
      print("values loaded ${_plotPoints}");
      emit(state.copyWith(_plotPoints));
    }
    catch(e){
      print("the error is $e");
      emit(FetchStateError(error: "$e"));
    }
  }

}


class FetchCubitDashboardDay extends Cubit<FetchState>{

  String device;
  DataModule? _dataModule;
  //start app with temporary values
  FetchCubitDashboardDay({required this.device}):super(
      FetchStateLoadedDashboard(

        dashboardData:[ "0 Watt", "0 Units", "0 INR"]))
  {
      _dataModule=DataModule(device: device);
      fetchDashboardData();
  }




  void fetchDashboardData() async{
    try{
      print("values are");
      List<String>? response=await _dataModule?.getDashboardDay();
      print("the response is $response");
      emit(FetchStateLoadedDashboard(dashboardData: response!.length==0?["0 Watt","0 Units","0 INR"]:response));
    }
    catch(e){
      emit(FetchStateError(error: "Value not loaded"));
    }
  }

}

class FetchCubitDashboardMonth extends Cubit<FetchState>{

  String device;
  DataModule? _dataModule;
  //start app with temporary values
  FetchCubitDashboardMonth({required this.device}):super(
      FetchStateLoadedDashboard(
        dashboardData:[ "0 Watt", "0 Units", "0 INR"]))
  {
      _dataModule=DataModule(device: device);
      fetchDashboardData();
  }




  void fetchDashboardData() async{
    try{
      print("values are");
      List<String>? response=await _dataModule?.getDashboardMonth();
      print("the response is $response");
      emit(FetchStateLoadedDashboard(dashboardData: response!.length==0?["0 Watt","0 Units","0 INR"]:response));
    }
    catch(e){
      emit(FetchStateError(error: "Value not loaded"));
    }
  }

}

class FetchCubitUnitValue extends Cubit<FetchState>{

  String device;
  DataModule? _dataModule;

  FetchCubitUnitValue({required this.device}):super(
    FetchStateValuesLoaded(value: 0)
  ){
    _dataModule=DataModule(device: device);
    fetchDataValues("hour", '1');
  }

  void fetchDataValues(String durationType,String duration) async{
    try{

      double? response=await _dataModule?.getUnitConsumptionData(durationType, duration);
      emit(FetchStateValuesLoaded(value: response!));
    }
    catch(e){
      print(e.toString());
    }
  }

}

class FetchCubitPowerValue extends Cubit<FetchState>{

  String device;
  DataModule? _dataModule;

  FetchCubitPowerValue({required this.device}):super(
    FetchStateValuesLoaded(value: 0)
  ){
    _dataModule=DataModule(device: device);
    fetchDataValues("hour", '1');
  }

  void fetchDataValues(String durationType,String duration) async{
    try{

      dynamic response=await _dataModule?.getPowerUsageBill(durationType, duration);
      emit(FetchStateValuesLoaded(value: response));
    }
    catch(e){
      print(e.toString());
    }
  }

}

class FetchCubitPowerFactor extends Cubit<FetchState>{

  String device;
  DataModule? _dataModule;

  FetchCubitPowerFactor({required this.device}):super(FetchStatePowerFactor(plotPoints: [])){
    _dataModule=DataModule(device: device);
  }

  void fetchData() async{
    try{
      List<PlotPoints>? response=await _dataModule?.getPowerFactor();
      emit(FetchStatePowerFactor(plotPoints: response!));
    }
    catch(e){
      print(e.toString());
    }
  }

}