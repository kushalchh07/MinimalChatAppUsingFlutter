part of 'internet_bloc.dart';

sealed class InternetState extends Equatable {
  const InternetState();
  
  @override
  List<Object> get props => [];
}

final class InternetInitial extends InternetState {}
