import 'dart:async';
import 'package:flutter/material.dart';

class DropchopSplashScreen extends StatefulWidget {
  const DropchopSplashScreen({super.key});

  @override
  State<DropchopSplashScreen> createState() => _DropchopSplashScreenState();
}

class _DropchopSplashScreenState extends State<DropchopSplashScreen> {
  @override
  void initState() {
    super.initState();

    // Standard static splash display window (3 seconds)
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        // Instant direct route navigation to your Home Screen
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      // The exact vibrant, signature green used by Bolt (#32BB78)
      backgroundColor: const Color(0xFF32BB78), 
      body: Stack(
        children: [
          // Exact Center Logo Placement (40% of screen width)
          Center(
            child: Image.asset(
              'images/logo.png',
              width: size.width * 0.40, 
              height: size.width * 0.40,
              fit: BoxFit.contain,
            ),
          ),

          // Bottom Center Branding Text Alignment
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
                        color: Color(0xFFE8F5E9), // Premium soft mint accent text color
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