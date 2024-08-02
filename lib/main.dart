import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/screens/auth/login_test.dart';
import 'package:astrology_app/screens/communication/chat/index.dart';
import 'package:astrology_app/screens/communication/video/index.dart';
import 'package:astrology_app/screens/communication/voice/index.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/screens/index.dart';
import 'package:astrology_app/screens/waiting_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final authenticationRepository = AuthenticationRepository();
  // await authenticationRepository.initialize();
  // await authenticationRepository.user.first;

  // runApp(App(authenticationRepository: authenticationRepository));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindaro Sewa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginTest(),
    );
  }
}
