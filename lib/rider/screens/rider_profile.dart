import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiderProfileScreen extends StatelessWidget {
  const RiderProfileScreen({super.key});

  void _handleLogout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFF32BB78),
                child: Icon(Icons.sports_motorsports, size: 50, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text('Alex Rider Fleet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out From Session', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => _handleLogout(context),
          ),
        )
      ],
    );
  }
}