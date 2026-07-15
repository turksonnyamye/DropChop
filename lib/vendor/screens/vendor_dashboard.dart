import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../vendor_order_controller.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> with SingleTickerProviderStateMixin {
  static const Color accent = Color(0xFF0EA37A);
  static const Color accentGlow = Color(0xFF6EFFC4);

  final VendorOrderController _controller = VendorOrderController();
  String selectedRange = '7D';
  int? selectedPointIndex;
  bool isRefreshing = false;

  final Map<String, List<double>> chartData = {
    '7D': [220, 340, 180, 400, 310, 450, 342],
    '30D': List.generate(30, (i) => 150 + (i * 13 % 300).toDouble()),
    '90D': List.generate(90, (i) => 100 + (i * 7 % 400).toDouble()),
  };

  final List<Map<String, dynamic>> transactions = [
    {'id': '#GA1042', 'name': 'Kwame Mensah', 'amount': 120.00, 'status': 'Completed', 'time': '12 mins ago'},
    {'id': '#GA1041', 'name': 'Ama Serwaa', 'amount': 240.00, 'status': 'Completed', 'time': '1 hr ago'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white54 : Colors.black54;

    // Financial Reconciliation Module calculation (assuming 25% standard default commission fee)
    double commissionRate = VendorOrderController.platformCommissionRate;
    double grossEarnings = transactions.fold(0.0, (sum, item) => sum + (item['amount'] as double));
    double netPayout = grossEarnings * (1 - commissionRate);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF07080A) : const Color(0xFFF3F5F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Financials', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: textPrimary)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accent, accent.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PENDING PAYOUT WEEKLY', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text('GHS ${netPayout.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Gross: GHS ${grossEarnings.toStringAsFixed(2)} | Platform Comm: ${(commissionRate * 100).toInt()}%', 
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white60, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Gross Metrics', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: CustomPaint(
                painter: _SparklinePainter(chartData[selectedRange]!, accent, accentGlow, selectedPointIndex),
              ),
            ),
            const SizedBox(height: 24),
            Text('Transactions Ledger', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
            const SizedBox(height: 12),
            ...transactions.map((tx) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx['name'] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: textPrimary)),
                      Text('${tx['id']} • ${tx['time']}', style: GoogleFonts.inter(color: textSecondary, fontSize: 12)),
                    ],
                  ),
                  Text('+ GHS ${(tx['amount'] as double).toStringAsFixed(2)}', 
                      style: GoogleFonts.inter(color: accent, fontWeight: FontWeight.w900)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color accent;
  final Color glow;
  final int? highlightIndex;

  _SparklinePainter(this.data, this.accent, this.glow, this.highlightIndex);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final widthStep = size.width / (data.length - 1);
    final points = <Offset>[];

    for (var i = 0; i < data.length; i++) {
      final x = i * widthStep;
      final y = size.height - ((data[i] - minVal) / range) * (size.height - 20) - 10;
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent.withOpacity(0.35), accent.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(colors: [accent, glow]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawCircle(points.last, 6, Paint()..color = glow.withOpacity(0.6)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
    canvas.drawCircle(points.last, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}