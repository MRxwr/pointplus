import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivitySuccess extends ConnectivityState {
  final List<ConnectivityResult> result;

  ConnectivitySuccess(this.result);

  @override
  List<Object> get props => [result];
}

class ConnectivityFailure extends ConnectivityState {}
