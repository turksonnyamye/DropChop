import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropchopSplashScreen extends StatefulWidget {
  const DropchopSplashScreen({super.key});

  @override
  State<DropchopSplashScreen> createState() => _DropchopSplashScreenState();
}

class _DropchopSplashScreenState extends State<DropchopSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialNavigation();
  }

  void _checkInitialNavigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String? savedRole = prefs.getString('userRole');

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        if (isLoggedIn) {
          switch (savedRole) {
            case 'buyer':
              Navigator.of(context).pushReplacementNamed('/buyerHome');
              break;
            case 'rider':
              Navigator.of(context).pushReplacementNamed('/riderHome');
              break;
            case 'vendor':
              Navigator.of(context).pushReplacementNamed('/vendorHome');
              break;
            default:
              Navigator.of(context).pushReplacementNamed('/selectUser');
          }
        } else {
          Navigator.of(context).pushReplacementNamed('/welcome');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF32BB78), 
      body: Stack(
        children: [
          Center(
            child: Icon(
              Icons.restaurant_menu_rounded,
              size: size.width * 0.30,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -0.8,
                  ),
                  children: [
                    TextSpan(
                      text: 'Drop',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'Chop',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE8F5E9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}