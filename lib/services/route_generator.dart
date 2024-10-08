import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/screens/auth/login.dart';
import 'package:astrology_app/screens/home/main.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generatorRoute(RouteSettings settings) {
    // ReceivedAction? receivedAction;
    // printWarning(settings.arguments);
    // if (settings.arguments != null && settings.arguments is ReceivedAction) {
    //   receivedAction = settings.arguments as ReceivedAction;
    // }
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const MainScreen());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (context) => const MainScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No Page Found 404',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            Center(
              child: Text(
                'Sorry No Page Found As Of Now',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            )
          ],
        ),
      );
    });
  }
}