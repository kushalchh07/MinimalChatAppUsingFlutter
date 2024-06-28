import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loginbloc_event.dart';
part 'loginbloc_state.dart';

class LoginblocBloc extends Bloc<LoginblocEvent, LoginblocState> {
  LoginblocBloc() : super(LoginblocInitial()) {
    on<LoginblocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
