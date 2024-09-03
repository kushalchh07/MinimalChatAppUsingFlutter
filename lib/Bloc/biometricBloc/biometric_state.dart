part of 'biometric_bloc.dart';

sealed class BiometricState extends Equatable {
  const BiometricState();
  
  @override
  List<Object> get props => [];
}

final class BiometricInitial extends BiometricState {}
