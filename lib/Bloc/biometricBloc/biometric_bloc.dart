import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  BiometricBloc() : super(BiometricInitial()) {
    on<BiometricEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
