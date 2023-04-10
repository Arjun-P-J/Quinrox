import "../../models/graphs_and_dataset.dart";




















abstract class FetchState<T>{
  FetchState copyWith(T value);
}

class FetchStateLoading extends FetchState<String>{

  FetchStateLoading copyWith(String value){
    return FetchStateLoading();
  }
}

class FetchStateLoadedGraphVI extends FetchState<List<PlotPoints>>{
  List<PlotPoints> plotPoints;
  FetchStateLoadedGraphVI({required this.plotPoints});

  FetchStateLoadedGraphVI copyWith(List<PlotPoints> plotPoints){
    return FetchStateLoadedGraphVI(plotPoints: plotPoints);
  }

}

class FetchStateLoadedPowerMonitorGraph extends FetchState<PowerSet>{

  PowerSet powerSet;
  FetchStateLoadedPowerMonitorGraph({required this.powerSet});

  FetchStateLoadedPowerMonitorGraph copyWith(PowerSet powerSet){
    return FetchStateLoadedPowerMonitorGraph(powerSet: powerSet);
  }

}

class FetchStateError extends FetchState<String>{
  String error;
  FetchStateError({required this.error});

  FetchStateError copyWith(String error){
    return FetchStateError(error: error);
  }
}

class FetchStateLoadedDashboard extends FetchState<List<String>>{
  List<String> dashboardData;
  FetchStateLoadedDashboard({required this.dashboardData});

  FetchStateLoadedDashboard copyWith(List<String> dashboardData){
    return FetchStateLoadedDashboard(dashboardData: dashboardData);
  }
}

class FetchStateValuesLoaded extends FetchState<double>{
  double value;
  FetchStateValuesLoaded({required this.value});

  FetchStateValuesLoaded copyWith(double value){
    return FetchStateValuesLoaded(value: value);
  }
}

class FetchStatePowerFactor extends FetchState<List<PlotPoints>>{
  List<PlotPoints> plotPoints;
  FetchStatePowerFactor({required this.plotPoints});
  FetchStatePowerFactor copyWith(List<PlotPoints> plotpoints){
    return FetchStatePowerFactor(plotPoints: plotPoints);
  }
}