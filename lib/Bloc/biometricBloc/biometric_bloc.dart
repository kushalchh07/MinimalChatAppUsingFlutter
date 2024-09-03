import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import 'biometric_event.dart';
import 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final LocalAuthentication _localAuth;

  BiometricBloc(this._localAuth) : super(BiometricInitial()) {
    on<CheckBiometricCapability>((event, emit) async {
      try {
        bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
        emit(BiometricCapabilityChecked(canCheckBiometrics));
      } catch (e) {
        emit(BiometricAuthenticationFailure(
            "Failed to check biometrics capability."));
      }
    });

    on<GetAvailableBiometrics>((event, emit) async {
      try {
        List<BiometricType> availableBiometrics =
            await _localAuth.getAvailableBiometrics();
        log(availableBiometrics.toString());
        emit(AvailableBiometricsLoaded(availableBiometrics));
      } catch (e) {
        emit(BiometricAuthenticationFailure(
            "Failed to get available biometrics."));
      }
    });

    on<AuthenticateWithBiometrics>((event, emit) async {
      try {
        bool authenticated = await _localAuth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          emit(BiometricAuthenticationSuccess());
        } else {
          emit(BiometricAuthenticationFailure("Authentication failed."));
        }
      } catch (e) {
        emit(BiometricAuthenticationFailure("Failed to authenticate."));
      }
    });
  }
}
