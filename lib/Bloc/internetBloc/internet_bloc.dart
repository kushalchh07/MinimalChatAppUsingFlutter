import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity;

  InternetBloc(this._connectivity) : super(InternetInitial()) {
    on<CheckInternet>(_onCheckInternet);
    on<InternetChanged>(_onInternetChanged);

    // Subscribe to connectivity changes
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResults) {
      add(InternetChanged(connectivityResults.first));
    });
  }

  void _onCheckInternet(
      CheckInternet event, Emitter<InternetState> emit) async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(InternetDisconnected());
    } else {
      emit(InternetConnected());
    }
  }

  void _onInternetChanged(InternetChanged event, Emitter<InternetState> emit) {
    if (event.connectivityResult == ConnectivityResult.none) {
      emit(InternetDisconnected());
    } else {
      emit(InternetConnected());
    }
  }
}
