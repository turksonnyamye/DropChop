import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/stat_card.dart';

class RiderDashboardScreen extends StatelessWidget {
  final List<Map<String, String>> activeOrders;
  final List<Map<String, String>> completedHistory;
  final double dailyEarnings;
  final int completedTrips;
  final Function(String) onCompleteOrder;

  const RiderDashboardScreen({
    super.key,
    required this.activeOrders,
    required this.completedHistory,
    required this.dailyEarnings,
    required this.completedTrips,
    required this.onCompleteOrder,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic percentage tracking based on a daily driver target goal of $150
    double dailyGoal = 150.0;
    double progressPercent = (dailyEarnings / dailyGoal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Performance Desk', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900)),
        const SizedBox(height: 24),

        // ADVANCED RADAR RADIAL RING DISPLAY CONTAINER
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      value: progressPercent,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF32BB78)),
                    ),
                  ),
                  Text(
                    '${(progressPercent * 100).toInt()}%',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SHIFT TARGET GOAL', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('\$${dailyEarnings.toStringAsFixed(2)} / \$150', style: GoogleFonts.inter(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text('Complete more pipeline jobs to hit daily target rewards.', style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            StatCard(title: 'Active Runs', value: '${activeOrders.length}', icon: Icons.motorcycle, iconColor: Colors.purple),
            const SizedBox(width: 12),
            StatCard(title: 'Finished Trips', value: '$completedTrips', icon: Icons.task_alt, iconColor: const Color(0xFF32BB78)),
          ],
        ),
        const SizedBox(height: 32),

        Text('Duty Settlement Logs', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        if (completedHistory.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text('No job manifests processed today.', style: GoogleFonts.inter(color: Colors.grey))),
          )
        else
          ...completedHistory.reversed.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['vendorName'] ?? 'App Vendor Order', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        Text('Manifest Ref #${item['id']}', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Text('+\$${item['payout']}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: const Color(0xFF32BB78), fontSize: 16)),
                  ],
                ),
              )),
      ],
    );
  }
}