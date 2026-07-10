// welcome_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Modern minimalist colors derived from the design
  static const Color brandGreen = Color(0xFF32BB78); // Updated to match your primary brand green
  static const Color textDark = Colors.black;
  static const Color textLight = Colors.white;
  static const Color backgroundWhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    // Media query to handle different screen sizes dynamically
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Header (Logo and Name)
                  Row(
                    children: [
                      // White logo wrapper: gives it a green circular background for clear visibility
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: brandGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'images/logo.png',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'DropChop',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04), // Increased top gap

                  // Hero Food Image (Centered and Larger)
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.85, // Increased from 0.75 to 0.85
                        maxHeight: screenHeight * 0.38, // Increased from 0.35 to 0.38
                      ),
                      child: Image.asset(
                        'images/waakye.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- BOTTOM SECTION ---
            const Spacer(), // Pushes the green container to the bottom
            Container(
              width: double.infinity,
              // Increased top and bottom padding to make the entire tab section taller
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
              decoration: const BoxDecoration(
                color: brandGreen,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w800, // Ultra bold
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Craving your favorites? Get local dishes and everyday essentials dropped at your doorstep, freshly chopped and ready to enjoy.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: textDark.withOpacity(0.8),
                      height: 1.5, // Line height for readability
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06), // Slightly increased spacing before buttons

                  // Button Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sign In Button (Black Pill)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signin');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: textLight,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      // Sign Up Button (White Pill)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: textDark,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: const StadiumBorder(),
                            side: BorderSide(color: textDark.withOpacity(0.1)),
                          ),
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}