import 'package:local_auth/local_auth.dart';

abstract class BiometricState {}
// enum BiometricType {
//   fingerprint,
//   face,
//   iris, // Note that this is rare
// }

class BiometricInitial extends BiometricState {}

class BiometricCapabilityChecked extends BiometricState {
  final bool isCapable;

  BiometricCapabilityChecked(this.isCapable);
}

class AvailableBiometricsLoaded extends BiometricState {
  final List<BiometricType> biometrics;

  AvailableBiometricsLoaded(this.biometrics);
}

class BiometricAuthenticationSuccess extends BiometricState {}

class BiometricAuthenticationFailure extends BiometricState {
  final String message;

  BiometricAuthenticationFailure(this.message);
}
