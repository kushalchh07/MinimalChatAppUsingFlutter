import 'package:chat_app/Api/firebase_api.dart';
import 'package:chat_app/Bloc/Signupbloc/signup_bloc.dart';
import 'package:chat_app/Bloc/chatBloc/chat_bloc.dart';

import 'package:chat_app/Bloc/loginbloc/login_bloc.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/SplashScreen&onBoard/splashScreen.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'your-recaptcha-v3-site-key', // If you're targeting web
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  await Api.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => SignupBloc(),
        ),
        BlocProvider(
          create: (context) => UserBloc(ChatService()),
        ),
        BlocProvider(
          create: (context) => ProfileImageBloc(FirebaseStorage.instance,
              FirebaseFirestore.instance, ImagePicker()),
        ),
        BlocProvider(
          create: (context) => ChatBloc(FirebaseFirestore.instance),
        ),
      ],
      child: GetMaterialApp(
        title: 'Guff Gaff',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: appSecondary),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
