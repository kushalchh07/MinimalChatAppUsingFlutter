import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../Bloc/biometricBloc/biometric_bloc.dart';
import '../../Bloc/biometricBloc/biometric_event.dart';
import '../../Bloc/biometricBloc/biometric_state.dart';

class BiometricAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BiometricBloc(LocalAuthentication())..add(CheckBiometricCapability()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Biometric Authentication'),
        ),
        body: BlocConsumer<BiometricBloc, BiometricState>(
          listener: (context, state) {
            // if (state is BiometricAuthenticationSuccess) {
            //   // Navigate to the next screen
            //   Navigator.pushReplacementNamed(context, '/home');
            // } else 
            if (state is BiometricAuthenticationFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is BiometricInitial ||
                state is BiometricCapabilityChecked) {
              return Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: greenColor,
                    foregroundColor: whiteColor,
                  ),
                  onPressed: () {
                    context.read<BiometricBloc>().add(GetAvailableBiometrics());
                  },
                  child: Text(
                    'Authenticate with Biometrics',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                        fontFamily: 'sans'),
                  ),
                ),
              );
            } else if (state is AvailableBiometricsLoaded) {
              final isempty = state.biometrics.isEmpty;
              return isempty
                  ? Center(child: Text('No biometrics available'))
                  : ListView(
                      children: state.biometrics
                          .map((biometric) =>
                              ListTile(title: Text(biometric.toString())))
                          .toList(),
                    ); 
            } else if (state is BiometricAuthenticationFailure) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
