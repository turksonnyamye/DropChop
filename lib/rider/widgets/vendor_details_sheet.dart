import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorDetailsSheet extends StatelessWidget {
  final Map<String, String> job;
  final VoidCallback onConfirmPickup;

  const VendorDetailsSheet({
    super.key,
    required this.job,
    required this.onConfirmPickup,
  });

  @override
  Widget build(BuildContext context) {
    // Mock vendor data synchronized with your vendor layer
    final String vendorName = job['vendorName'] ?? 'Gourmet Kitchen';
    final String vendorRating = job['vendorRating'] ?? '4.8';
    final List<String> itemsToCollect = ['2x Deluxe Beef Burgers', '1x Large Fries', '1x Oreo Milkshake'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('COLLECT FROM VENDOR', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(vendorName, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(vendorRating, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                  ],
                ),
              )
            ],
          ),
          const Divider(height: 32),
          Text('Order Items Manifest', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          
          // Generate checklist matching what the vendor cooked
          ...itemsToCollect.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.check_box_outlined, color: Color(0xFF32BB78), size: 20),
                const SizedBox(width: 12),
                Text(item, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800)),
              ],
            ),
          )),
          
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF32BB78),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: onConfirmPickup,
              child: Text('Confirm Collection from Vendor', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}