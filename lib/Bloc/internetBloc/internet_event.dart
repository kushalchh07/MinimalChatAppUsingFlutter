part of 'internet_bloc.dart';

abstract class InternetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckInternet extends InternetEvent {}

class InternetChanged extends InternetEvent {
  final ConnectivityResult connectivityResult;

  InternetChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult];
}
