import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_event.dart';
import 'connection_state.dart';


class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityBloc(this._connectivity) : super(ConnectivityInitial()) {
    on<ConnectivityChanged>(_onConnectivityChanged);

    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      add(ConnectivityChanged(result));
    });

    // Check the initial connectivity status
    _checkInitialConnectivity();
  }

  void _onConnectivityChanged(
      ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    if (!event.result.contains(ConnectivityResult.none)) {
      emit(ConnectivitySuccess(event.result));
    } else {
      emit(ConnectivityFailure());
    }
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    add(ConnectivityChanged(result));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
