import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/vendor_dashboard.dart';
import 'screens/vendor_orders.dart';
import 'screens/vendor_couriers.dart';
import 'screens/vendor_profile.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  static const Color accent = Color(0xFF0EA37A);
  static const Color accentGlow = Color(0xFF6EFFC4);

  int _currentIndex = 1; // Defaults to active Live Orders

  final List<Widget> _screens = [
    const VendorDashboardScreen(),
    const VendorOrderManagerScreen(),
    const VendorCouriersScreen(),
    const VendorProfileScreen(),
  ];

  final List<Map<String, dynamic>> _tabs = const [
    {'icon': Icons.analytics_outlined, 'activeIcon': Icons.analytics_rounded, 'label': 'Earnings'},
    {'icon': Icons.list_alt_outlined, 'activeIcon': Icons.list_alt_rounded, 'label': 'Orders'},
    {'icon': Icons.delivery_dining_outlined, 'activeIcon': Icons.delivery_dining_rounded, 'label': 'Couriers'},
    {'icon': Icons.storefront_outlined, 'activeIcon': Icons.storefront_rounded, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF0E1114) : Colors.white;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBg,
          border: Border(
            top: BorderSide(color: (isDark ? Colors.white : Colors.black).withOpacity(0.06)),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final selected = _currentIndex == index;
                final tab = _tabs[index];
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? accent.withOpacity(0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        selected
                            ? ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(colors: [accent, accentGlow]).createShader(bounds),
                                child: Icon(tab['activeIcon'] as IconData, size: 20, color: Colors.white),
                              )
                            : Icon(tab['icon'] as IconData, size: 20, color: isDark ? Colors.white38 : Colors.black38),
                        const SizedBox(height: 3),
                        Text(
                          tab['label'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: selected ? accent : (isDark ? Colors.white38 : Colors.black38),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}