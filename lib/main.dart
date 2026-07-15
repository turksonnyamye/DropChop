import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/welcome_page.dart'; 
import 'screens/sign_in_page.dart';
import 'screens/sign_up_page.dart'; 
import 'screens/user_selection_page.dart';
import 'rider/rider_home.dart';
import 'vendor/vendor_home.dart';
import 'buyer/buyer_page.dart'; // Renamed standard snake_case file path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, 
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? savedRole = prefs.getString('userRole');

  String initialRoute = '/welcome';

  if (isLoggedIn) {
    switch (savedRole) {
      case 'buyer':
        initialRoute = '/buyerHome';
        break;
      case 'rider':
        initialRoute = '/riderHome';
        break;
      case 'vendor':
        initialRoute = '/vendorHome';
        break;
      default:
        initialRoute = '/selectUser';
    }
  }

  runApp(DropchopApp(initialRoute: initialRoute));
}

class DropchopApp extends StatelessWidget {
  final String initialRoute;
  const DropchopApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DropChop',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF32BB78),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF32BB78),
          primary: const Color(0xFF32BB78),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/selectUser': (context) => const UserSelectionPage(),
        '/buyerHome': (context) => const BuyerPage(),
        '/riderHome': (context) => const RiderHomePage(),
        '/vendorHome': (context) => const VendorHomePage(),
      },
    );
  }
}