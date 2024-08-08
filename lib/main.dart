import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/repository/authentication_repository.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/auth/login_test.dart';
import 'package:astrology_app/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App(authenticationRepository: AuthenticationRepository()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthenticationRepository()),
        )
      ],
      child: MaterialApp(
        title: 'Mindaro Sewa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginTest(),
      ),
    );
  }
}
