import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_page.dart'; 
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart'; 

void main() {
  // Ensure framework bindings are ready before setting system configurations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set premium UI status bar overlays matching top food apps
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.dark, // Dark status bar text on light backgrounds
    statusBarBrightness: Brightness.light,    // For iOS device compatibility
  ));

  runApp(const DropchopApp());
}

class DropchopApp extends StatelessWidget {
  const DropchopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dropchop',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF32BB78),
        colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF32BB78),
        primary: const Color(0xFF32BB78),
           ),
      ),
      // Define named routing map for scalability
      initialRoute: '/',
      routes: {
        '/': (context) => const DropchopSplashScreen(),
        '/home': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
         
      },
    );
  }
}