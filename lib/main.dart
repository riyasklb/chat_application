
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/navigation_service.dart';
import 'package:chat_application/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupfirebase();
  await registerservice();
}

class MyApp extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  late NavigationService _navigationService;
  late AuthService _authService;
  MyApp({super.key}) {
    _navigationService = getIt.get<NavigationService>();
    _authService = getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorkey,
      title: 'chat app',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: _determineInitialRoute(),
      routes: _navigationService.routes,
    );
  }


    String _determineInitialRoute() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return '/login';
    } else {
      return '/home';
    }
  }

}
