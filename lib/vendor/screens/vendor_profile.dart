// lib/vendor/screens/vendor_profile.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  static const Color accent = Color(0xFF0EA37A);
  static const Color accentGlow = Color(0xFF6EFFC4);

  bool acceptingOrders = true;
  bool autoAcceptOrders = false;
  bool notifyNewOrder = true;

  final Map<String, bool> businessDays = {
    'Mon': true, 'Tue': true, 'Wed': true, 'Thu': true, 'Fri': true, 'Sat': true, 'Sun': false,
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF07080A) : const Color(0xFFF3F5F7);
    final cardColor = isDark ? Colors.white.withOpacity(0.06) : Colors.white;
    final borderColor = (isDark ? Colors.white : Colors.black).withOpacity(0.08);
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            _buildHero(cardColor, borderColor, textPrimary, textSecondary, isDark),
            const SizedBox(height: 20),
            _buildStatsRow(cardColor, borderColor, textPrimary, textSecondary),
            const SizedBox(height: 28),
            _buildSectionLabel('Business Hours', textSecondary),
            const SizedBox(height: 12),
            _buildHoursPanel(cardColor, borderColor, textPrimary, textSecondary),
            const SizedBox(height: 28),
            _buildSectionLabel('Operational Switches', textSecondary),
            const SizedBox(height: 12),
            _buildSwitchPanel(cardColor, borderColor, textPrimary, textSecondary),
            const SizedBox(height: 28),
            _buildSectionLabel('Account', textSecondary),
            const SizedBox(height: 12),
            _buildAccountPanel(cardColor, borderColor, textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(Color cardColor, Color borderColor, Color textPrimary, Color textSecondary, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(28), border: Border.all(color: borderColor)),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [accent, accentGlow]), boxShadow: [BoxShadow(color: accent.withOpacity(0.35), blurRadius: 20)]),
                child: CircleAvatar(radius: 42, backgroundColor: isDark ? const Color(0xFF07080A) : Colors.white, child: const Icon(Icons.fastfood_rounded, size: 36, color: accent)),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: GestureDetector(
                  onTap: () => _editStoreName(context, textPrimary, isDark),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: accent, border: Border.all(color: isDark ? const Color(0xFF07080A) : Colors.white, width: 2)),
                    child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Campus Eats Gourmet Kitchen', textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 4),
          Text('Vendor since 2025', style: GoogleFonts.inter(fontSize: 12, color: textSecondary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [accent, accentGlow]), borderRadius: BorderRadius.circular(12)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.verified_rounded, size: 13, color: Colors.white),
              const SizedBox(width: 5),
              Text('VERIFIED MERCHANT', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.4)),
            ]),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _shareStoreLink(context),
            icon: Icon(Icons.share_rounded, size: 16, color: textPrimary),
            label: Text('Share Store Link', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ],
      ),
    );
  }

  void _editStoreName(BuildContext context, Color textPrimary, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF14161A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Store Name', style: GoogleFonts.inter(color: textPrimary, fontWeight: FontWeight.w700)),
        content: TextField(
          controller: TextEditingController(text: 'Campus Eats Gourmet Kitchen'),
          style: GoogleFonts.inter(color: textPrimary),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: accent),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _shareStoreLink(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Store link copied to clipboard', style: GoogleFonts.inter()), backgroundColor: accent, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    );
  }

  Widget _buildStatsRow(Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Row(
      children: [
        Expanded(child: _statCard('Store Rating', '4.85', Icons.star_rounded, const Color(0xFFFFC94D), cardColor, borderColor, textPrimary, textSecondary, suffix: '★')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Prep Time Avg', '12', Icons.timer_rounded, const Color(0xFF4EA1FF), cardColor, borderColor, textPrimary, textSecondary, suffix: ' mins')),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, Color cardColor, Color borderColor, Color textPrimary, Color textSecondary, {String suffix = ''}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.inter(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('$value$suffix', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w900, color: textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color textSecondary) {
    return Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.3, color: textSecondary));
  }

  Widget _buildHoursPanel(Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: businessDays.keys.map((day) {
          final active = businessDays[day]!;
          return GestureDetector(
            onTap: () => setState(() => businessDays[day] = !active),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42, height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: active ? const LinearGradient(colors: [accent, accentGlow]) : null,
                color: active ? null : textSecondary.withOpacity(0.1),
              ),
              child: Text(day.substring(0, 1), style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 13, color: active ? Colors.white : textSecondary)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSwitchPanel(Color cardColor, Color borderColor, Color textPrimary, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        children: [
          _switchRow(Icons.storefront_rounded, 'Accepting New Orders', 'Toggle off to pause your storefront', acceptingOrders, textPrimary, textSecondary, (v) => setState(() => acceptingOrders = v)),
          Divider(height: 1, color: borderColor),
          _switchRow(Icons.flash_on_rounded, 'Auto-Accept Orders', 'Skip manual confirmation for new orders', autoAcceptOrders, textPrimary, textSecondary, (v) => setState(() => autoAcceptOrders = v)),
          Divider(height: 1, color: borderColor),
          _switchRow(Icons.notifications_active_rounded, 'New Order Alerts', 'Push notification for each new order', notifyNewOrder, textPrimary, textSecondary, (v) => setState(() => notifyNewOrder = v)),
        ],
      ),
    );
  }

  Widget _switchRow(IconData icon, String title, String subtitle, bool value, Color textPrimary, Color textSecondary, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: accent.withOpacity(0.14), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 18, color: accent)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.inter(fontSize: 11, color: textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(value: value, activeColor: accent, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildAccountPanel(Color cardColor, Color borderColor, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: borderColor)),
      child: Column(
        children: [
          _navRow(Icons.storefront_rounded, 'Store Details', textPrimary, borderColor, () {}),
          Divider(height: 1, color: borderColor),
          _navRow(Icons.payments_rounded, 'Payout Settings (MoMo)', textPrimary, borderColor, () {}),
          Divider(height: 1, color: borderColor),
          _navRow(Icons.description_rounded, 'Documents & Verification', textPrimary, borderColor, () {}),
          Divider(height: 1, color: borderColor),
          _navRow(Icons.logout_rounded, 'Log Out', textPrimary, borderColor, () => _confirmLogout(context), color: const Color(0xFFFF5A5F)),
        ],
      ),
    );
  }

  Widget _navRow(IconData icon, String title, Color textPrimary, Color borderColor, VoidCallback onTap, {Color? color}) {
    final c = color ?? textPrimary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(color: (color ?? accent).withOpacity(0.14), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 18, color: color ?? accent)),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: c))),
            Icon(Icons.chevron_right_rounded, color: textPrimary.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF14161A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log out?', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87)),
        content: Text('You\'ll need to sign in again to manage this store.', style: GoogleFonts.inter(color: isDark ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            // Actually logs out now: clears saved session and returns to Welcome.
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A5F)),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}