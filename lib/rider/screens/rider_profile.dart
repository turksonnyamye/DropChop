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
        // Driver Identity Frame
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFF32BB78),
                child: Icon(Icons.sports_motorsports, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text('Alex Rider Fleet', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                child: Text('GOLD LEVEL DRIVER', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              )
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Stars & Performance Scorecards
        Row(
          children: [
            _buildMetricBox('User Rating', '4.92 ★', Colors.amber),
            const SizedBox(width: 12),
            _buildMetricBox('Acceptance', '98%', Colors.blue),
          ],
        ),
        const SizedBox(height: 40),

        Text('Account Actions', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
        const Divider(),
        const SizedBox(height: 8),

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

  Widget _buildMetricBox(String title, String data, Color themeColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(data, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: themeColor)),
          ],
        ),
      ),
    );
  }
}