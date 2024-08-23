import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
