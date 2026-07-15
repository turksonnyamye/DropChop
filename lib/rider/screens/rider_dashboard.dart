import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Premium customizable metrics
    double dailyGoal = 150.0;
    double progressPercent = (dailyEarnings / dailyGoal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Title Header
        Text(
          'Performance Desk', 
          style: GoogleFonts.inter(
            fontSize: 26, 
            fontWeight: FontWeight.w900, 
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 24),
        
        // Premium Dark Slate Gradient Wallet Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TODAY\'S WALLET', 
                        style: GoogleFonts.inter(
                          color: Colors.white60, 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'GHS ${dailyEarnings.toStringAsFixed(2)}', 
                        style: GoogleFonts.inter(
                          color: Colors.white, 
                          fontSize: 32, 
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  
                  // Radial Goal Progress Tracker
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: progressPercent,
                          backgroundColor: Colors.white10,
                          strokeWidth: 6,
                          color: const Color(0xFF32BB78),
                        ),
                        Center(
                          child: Text(
                            '${(progressPercent * 100).toInt()}%',
                            style: GoogleFonts.inter(
                              color: Colors.white, 
                              fontSize: 12, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 16),
              
              // Secondary Mini-Stats row inside Wallet Card
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_motorsports_outlined, color: Colors.white54, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '$completedTrips Completed Runs',
                        style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    'Goal: GHS ${dailyGoal.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        // Logs Segment
        Text(
          'Duty Settlement Logs', 
          style: GoogleFonts.inter(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        
        // Dynamic completion list view conditional check
        if (completedHistory.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No job manifests processed today.', 
                    style: GoogleFonts.inter(
                      color: Colors.grey, 
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...completedHistory.reversed.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Completion Badge
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F8F0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.check_circle_rounded, color: Color(0xFF32BB78), size: 20),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['vendorName'] ?? 'App Vendor Order', 
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800, 
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manifest Ref #${item['id']}', 
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade500, 
                                fontSize: 12, 
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '+GHS ${item['payout']}', 
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900, 
                        color: const Color(0xFF32BB78), 
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )),
      ],
    );
  }
}