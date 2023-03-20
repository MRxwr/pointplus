import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier{
  String notification = "0";
  changeNotification(String value){
    notification = value;
    notifyListeners();
  }

}