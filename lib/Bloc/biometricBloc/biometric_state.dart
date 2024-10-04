import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

/// Base class for all Biometric states
abstract class BiometricState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state before any actions are performed
class BiometricInitial extends BiometricState {}

/// State when the device's biometric capability has been checked
class BiometricCapabilityChecked extends BiometricState {
  final bool canCheckBiometrics;

  BiometricCapabilityChecked(this.canCheckBiometrics);

  @override
  List<Object?> get props => [canCheckBiometrics];
}

/// State when available biometric methods are successfully loaded
class AvailableBiometricsLoaded extends BiometricState {
  final List<BiometricType> biometrics;
  final Map<BiometricType, bool> enabledBiometrics;

  AvailableBiometricsLoaded(this.biometrics, this.enabledBiometrics);

  @override
  List<Object?> get props => [biometrics, enabledBiometrics];
}

/// State when biometric authentication succeeds
class BiometricAuthenticationSuccess extends BiometricState {}

/// State when biometric authentication fails or throws an error
class BiometricAuthenticationFailure extends BiometricState {
  final String message;

  BiometricAuthenticationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
