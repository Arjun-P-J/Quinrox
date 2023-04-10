import "package:shared_preferences/shared_preferences.dart";


























class DeviceStoredValues{

    SharedPreferences? _prefs;

    //initialize the shared preferences
    Future accessDeviceValues() async{
      try {
        _prefs = await SharedPreferences.getInstance();
        return _prefs;
      }
      catch(e){
        print(e.toString());
      }
    }

    //Future get data
    Future<String?> getData(String key) async{
      try{
        _prefs=await SharedPreferences.getInstance();
         await _prefs?.getString(key);
      }
      catch(e){
        return "No Device";
      }
    }

    //store values in shared preferenecs
    Future<void> storeData(String key,String value) async{
      try {
        _prefs=await SharedPreferences.getInstance();
        dynamic response=await _prefs?.setString(key, value);
        print("the value is $value and stored is $response");
      }
      catch(e){
        print(e.toString());
      }
    }

    //remove data from values in shared preference
    Future<void> removeData(String key) async{
      try {
        _prefs=await SharedPreferences.getInstance();
        await _prefs?.remove(key);
      }
      catch(e){
        print(e.toString());
      }
    }

    //delete shared preference
    Future<void> deleteDeviceValues() async{
      try{
        _prefs=await SharedPreferences.getInstance();
        await _prefs?.clear();
      }
      catch(e){
        print(e.toString());
      }
    }


}