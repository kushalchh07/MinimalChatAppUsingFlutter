import 'dart:developer';

import 'package:chat_app/Bloc/biometricBloc/biometric_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'biometric_event.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final LocalAuthentication _localAuth;

  BiometricBloc(this._localAuth) : super(BiometricInitial()) {
    on<CheckBiometricCapability>(_onCheckBiometricCapability);
    on<GetAvailableBiometrics>(_onGetAvailableBiometrics);
    on<ToggleBiometric>(_onToggleBiometric);
    on<AuthenticateWithBiometrics>(_onAuthenticateWithBiometrics);
    on<GetEnabledBiometrics>(_onGetEnabledBiometrics);
  }

  /// Logic for checking if the device can use biometrics
  Future<void> _onCheckBiometricCapability(
      CheckBiometricCapability event, Emitter<BiometricState> emit) async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      emit(BiometricCapabilityChecked(canCheckBiometrics));
    } catch (e) {
      emit(BiometricAuthenticationFailure(
          "Failed to check biometrics capability."));
    }
  }

  /// Logic for fetching available biometrics and loading enabled biometrics state
  Future<void> _onGetAvailableBiometrics(
      GetAvailableBiometrics event, Emitter<BiometricState> emit) async {
    try {
      List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();
      final prefs = await SharedPreferences.getInstance();
      Map<BiometricType, bool> enabledBiometrics = {};

      // Load enabled/disabled state from SharedPreferences for each biometric method
      for (var biometric in availableBiometrics) {
        bool isEnabled =
            prefs.getBool(biometric.toString()) ?? false; // default to false
        enabledBiometrics[biometric] = isEnabled;
      }

      // Emit the state with available and enabled biometrics
      emit(AvailableBiometricsLoaded(availableBiometrics, enabledBiometrics));
    } catch (e) {
      emit(BiometricAuthenticationFailure(
          "Failed to get available biometrics."));
    }
  }

  /// Logic for toggling biometrics (enable/disable) and persisting state
  Future<void> _onToggleBiometric(
      ToggleBiometric event, Emitter<BiometricState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save the toggle state to SharedPreferences
      await prefs.setBool(event.biometricType.toString(), event.isEnabled);
      await prefs.setBool('faceBiometric', event.isEnabled);

      // Update the state with the new biometric toggle state
      if (state is AvailableBiometricsLoaded) {
        final biometricsState = state as AvailableBiometricsLoaded;
        Map<BiometricType, bool> updatedEnabledBiometrics =
            Map.from(biometricsState.enabledBiometrics);

        // Update the enabled state of the specific biometric
        updatedEnabledBiometrics[event.biometricType] = event.isEnabled;

        // Emit updated state
        emit(AvailableBiometricsLoaded(
            biometricsState.biometrics, updatedEnabledBiometrics));
      }
    } catch (e) {
      emit(BiometricAuthenticationFailure("Failed to toggle biometric state."));
    }
  }

  /// Logic for authenticating using biometrics
  Future<void> _onAuthenticateWithBiometrics(
      AuthenticateWithBiometrics event, Emitter<BiometricState> emit) async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to sign in',
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
      emit(BiometricAuthenticationFailure(
          "Failed to authenticate using biometrics."));
    }
  }

  Future<void> _onGetEnabledBiometrics(
      GetEnabledBiometrics event, Emitter<BiometricState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<BiometricType> enabledBiometricsList = [];

      // Check which biometrics are enabled
      for (BiometricType biometric in BiometricType.values) {
        log("Checking for ${biometric.toString()}");
        if (prefs.getBool(biometric.toString()) == true) {
          log("Enabled biometric: ${biometric.toString()}");
          enabledBiometricsList.add(biometric);
        } else {
          log("Disabled biometric: ${biometric.toString()}");
        }
      }
      log("Enabled biometrics: $enabledBiometricsList");
      // Emit a new state with the list of enabled biometrics
      Map<BiometricType, bool> enabledBiometricsMap = {};
      enabledBiometricsList.forEach((biometric) {
        enabledBiometricsMap[biometric] = true;
      });
      log("Enabled biometrics map: $enabledBiometricsMap");
      emit(AvailableBiometricsLoaded(
          enabledBiometricsList, enabledBiometricsMap));
    } catch (e) {
      log("Failed to get enabled biometrics: $e");
      emit(BiometricAuthenticationFailure("Failed to get enabled biometrics."));
    }
  }
}
