
import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/blocs/video_call/video_call_bloc.dart';
import 'package:astrology_app/repository/chat_repository.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/auth/login.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/utils/firebase_data_source.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AppBloc(authenticationRepository: _authenticationRepository),
          ),
          BlocProvider(
            create: (_) => AuthBloc(authRepository: _authenticationRepository),
          ),
          BlocProvider(
            create: (_) => ChatBloc(ChatRepository()),
          ),
          BlocProvider(
            create: (_) => WebRTCBloc(FirebaseDataSource()),
          )
        ],
        child: const AppView(),
      ),
    );
  }
}


class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindaro Sewa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: (status, pages) {
          if (status == AppStatus.authenticated) {
            return [const MaterialPage(child: HomeScreen())];
          }
          return [const MaterialPage(child: LoginScreen())];
        },
      ),
    );
  }
}
