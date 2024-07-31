import 'package:point/app/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageService{
  late final SharedPreferences _prefs;
  Future<StorageService> init()async{
    _prefs = await SharedPreferences.getInstance();
    return this;
  }
 Future<bool> setBool(String key, bool value)async{
    return await _prefs.setBool(key, value);

  }
  Future<bool> setString(String key, String value)async{
    return await _prefs.setString(key, value);

  }
  bool getDeviceFirstOpen(){
    return  _prefs.getBool(Constant.STORAGE_DEVICE_OPEN_FIRST_TIME)??false;

  }

  bool getIsLoggedIn(){
    return  _prefs.getString(Constant.STORAGE_USER_TOKEN_KEY)== null? false:true;

  }
  Future<bool> remove(String key){
    return _prefs.remove(key);
    
  }
}
