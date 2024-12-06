import 'package:chat_app/Api/firebase_api.dart';
import 'package:chat_app/Bloc/GroupChatBloc/groupchat_bloc.dart';
import 'package:chat_app/Bloc/GroupInfoBloc/group_info_bloc.dart';
import 'package:chat_app/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:chat_app/Bloc/Signupbloc/signup_bloc.dart';
import 'package:chat_app/Bloc/StoriesBloc/stories_bloc.dart';
import 'package:chat_app/Bloc/biometricBloc/biometric_bloc.dart';
import 'package:chat_app/Bloc/chatBloc/chat_bloc.dart';
import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_bloc.dart';
import 'package:chat_app/Bloc/gourpmessageBloc/group_message_bloc.dart';
import 'package:chat_app/Bloc/internetBloc/internet_bloc.dart';

import 'package:chat_app/Bloc/loginbloc/login_bloc.dart';
import 'package:chat_app/Bloc/passwordbloc/password_bloc.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';

import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/SplashScreen&onBoard/splashScreen.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_emoji_gif_picker/flutter_emoji_gif_picker.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';

import 'Bloc/ImagePicker/image_picker_bloc.dart';
import 'theme/ThemeCubit/theme_cubit.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // webRecaptchaSiteKey: 'your-recaptcha-v3-site-key', // If you're targeting web
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Message received: ${message.notification?.title}');
  });

  // Handle background messages
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // print('Message clicked!');
  });

  await Api.init();
  EmojiGifPickerPanel.setup(
      sizes: MenuSizes(width: 2000, height: 500),
      texts: MenuTexts(
          searchEmojiHintText: "Search Emoji?",
          searchGifHintText: "Search with Giphy"),
      colors: MenuColors(
        backgroundColor: const Color(0xFFf6f5f3),
        searchBarBackgroundColor: Colors.white,
        searchBarBorderColor: const Color(0xFFe6e5e2),
        searchBarEnabledColor: Colors.white,
        searchBarFocusedColor: const Color(0xFF00a884),
        menuSelectedIconColor: const Color(0xFF1d6e5f),
        buttonColor: const Color(0xFF909090),
        iconBackgroundColor: null,
        iconHoveredBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
        indicatorColor: Colors.transparent,
      ),
      styles: MenuStyles(
          menuSelectedTextStyle:
              const TextStyle(fontSize: 20, color: Colors.black),
          menuUnSelectedTextStyle:
              const TextStyle(fontSize: 20, color: Color(0xFF7a7a7a)),
          searchBarHintStyle:
              const TextStyle(fontSize: 12, color: Color(0xFF8d8d8d)),
          searchBarTextStyle:
              const TextStyle(fontSize: 12, color: Colors.black)),
      giphyApiKey: "yourgiphyapikey",
      mode: Mode.light);
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
        BlocProvider(
          create: (context) => PasswordBloc(),
        ),
        BlocProvider(
          create: (context) => GroupchatBloc(),
        ),
        BlocProvider(
          create: (context) => StoriesBloc(),
        ),
        BlocProvider(
          create: (context) => FetchStoryBloc(),
        ),
        BlocProvider(
          create: (context) => FriendRequestBloc(FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => GroupMessageBloc(),
        ),
        BlocProvider(
          create: (context) => GroupInfoBloc(
            firestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance,
          ),
        ),
        BlocProvider(
          create: (context) => ImagePickerBloc(),
        ),
        BlocProvider(
          create: (context) => BiometricBloc(LocalAuthentication()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) =>
              InternetBloc(Connectivity())..add(CheckInternet()),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return GetMaterialApp(
            title: 'Guff Gaff',
            theme: AppTheme.themeData(state.isDarkThemeOn, context),
          
            home:const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
