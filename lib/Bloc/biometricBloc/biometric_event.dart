import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

/// Base class for all Biometric events
abstract class BiometricEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to check if the device is capable of using biometrics
class CheckBiometricCapability extends BiometricEvent {}

/// Event to get the available biometric methods on the device
class GetAvailableBiometrics extends BiometricEvent {}

/// Event to toggle a specific biometric method on or off
class ToggleBiometric extends BiometricEvent {
  final BiometricType biometricType;
  final bool isEnabled;

  ToggleBiometric(this.biometricType, this.isEnabled);

  @override
  List<Object?> get props => [biometricType, isEnabled];
}

/// Event to authenticate using the enabled biometric method(s)
class AuthenticateWithBiometrics extends BiometricEvent {}
class GetEnabledBiometrics extends BiometricEvent {}