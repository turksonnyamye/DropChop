import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorCouriersScreen extends StatefulWidget {
  const VendorCouriersScreen({super.key});

  @override
  State<VendorCouriersScreen> createState() => _VendorCouriersScreenState();
}

class _VendorCouriersScreenState extends State<VendorCouriersScreen> {
  static const Color accent = Color(0xFF0EA37A);
  static const Color accentGlow = Color(0xFF6EFFC4);

  String searchQuery = '';

  final List<Map<String, dynamic>> activeRiders = [
    {'name': 'Alex Rider Fleet', 'status': 'Arrived at Store', 'phone': '+233 24 234 5678', 'rating': '4.92', 'orderId': '#2019', 'etaMins': 0},
    {'name': 'Jordan Delivery', 'status': 'En Route', 'phone': '+233 20 876 5432', 'rating': '4.78', 'orderId': '#8842', 'etaMins': 3},
  ];

  List<Map<String, dynamic>> get filtered {
    if (searchQuery.isEmpty) return activeRiders;
    final q = searchQuery.toLowerCase();
    return activeRiders.where((r) => 
        (r['name'] as String).toLowerCase().contains(q) || 
        (r['orderId'] as String).toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF07080A) : const Color(0xFFF3F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Couriers Tracking', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: textPrimary)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search rider name or order ID...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text('No active couriers found.', style: GoogleFonts.inter(color: textSecondary)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, i) {
                        final rider = filtered[i];
                        return _buildRiderCard(rider, isDark, textPrimary, textSecondary);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderCard(Map<String, dynamic> rider, bool isDark, Color textPrimary, Color textSecondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: accent,
                child: Icon(Icons.sports_motorsports_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rider['name'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: textPrimary)),
                    Text('Status: ${rider['status']} • ETA: ${rider['etaMins']} mins', style: GoogleFonts.inter(color: accent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Order ${rider['orderId']}', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textPrimary)),
                  Text('${rider['rating']} ★', style: GoogleFonts.inter(color: Colors.amber.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_rounded, size: 18, color: Colors.white),
                  label: const Text('Call Rider', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent, 
                    padding: const EdgeInsets.symmetric(vertical: 12), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline_rounded, size: 18, color: textPrimary),
                  label: Text('Message', style: GoogleFonts.inter(color: textPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}