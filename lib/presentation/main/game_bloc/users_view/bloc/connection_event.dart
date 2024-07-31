import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final List<ConnectivityResult> result;

  ConnectivityChanged(this.result);

  @override
  List<Object> get props => [result];
}
