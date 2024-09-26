import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/blocs/user/user_bloc.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/repository/index.dart';
import 'package:astrology_app/screens/auth/login.dart';
import 'package:astrology_app/screens/home/cubits/home_cubit.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:astrology_app/services/route_generator.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.navigatorKey,
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;
  final GlobalKey<NavigatorState> navigatorKey;

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
            create: (_) => HomeCubit(),
          ),
          BlocProvider(
            create: (_) => UserBloc(),
          )
        ],
        child: AppView(navigatorKey: navigatorKey),
      ),
    );
  }
}


class AppView extends StatelessWidget {
  const AppView({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindaro Sewa',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generatorRoute,
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
