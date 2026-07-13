import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vendor_order_controller.dart'; // Import controller file

class VendorOrderManagerScreen extends StatefulWidget {
  const VendorOrderManagerScreen({super.key});

  @override
  State<VendorOrderManagerScreen> createState() => _VendorOrderManagerScreenState();
}

class _VendorOrderManagerScreenState extends State<VendorOrderManagerScreen> {
  // Instantiate the local state engine wrapper
  final VendorOrderController _controller = VendorOrderController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final merchantOrders = _controller.orders;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Merchant Order Board',
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF32BB78).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront, color: Color(0xFF32BB78), size: 18),
                const SizedBox(width: 6),
                Text(
                  'STORE: OPEN',
                  style: GoogleFonts.inter(color: const Color(0xFF32BB78), fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: merchantOrders.length,
        itemBuilder: (context, index) {
          final order = merchantOrders[index];
          return _buildPremiumMerchantCard(order, index);
        },
      ),
    );
  }

  Widget _buildPremiumMerchantCard(Map<String, dynamic> order, int index) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.cookie_outlined;
    String actionButtonText = 'Move to Kitchen Cooking';

    if (order['status'] == 'Preparing') {
      statusColor = Colors.blue;
      statusIcon = Icons.outdoor_grill_rounded;
      actionButtonText = 'Mark as Ready for Courier';
    } else if (order['status'] == 'Ready for Pickup') {
      statusColor = const Color(0xFF32BB78);
      statusIcon = Icons.assignment_turned_in_rounded;
      actionButtonText = 'Handover to Fleet Courier';
    } else if (order['status'] == 'Dispatched') {
      statusColor = Colors.grey;
      statusIcon = Icons.delivery_dining_rounded;
      actionButtonText = 'Run Finalized';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MANIFEST ID #${order['id']}',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order['clientName'],
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        order['status'].toUpperCase(),
                        style: GoogleFonts.inter(color: statusColor, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kitchen Preparation List',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                ...(order['items'] as List<String>).map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.black38),
                          const SizedBox(width: 10),
                          Text(
                            item,
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          // Intersecting matching container layout displaying active courier profile
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2229), 
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF32BB78),
                      child: Icon(Icons.sports_motorsports_rounded, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ASSIGNED COURIER',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white60),
                        ),
                        Text(
                          order['assignedRider'],
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    order['riderRating'],
                    style: GoogleFonts.inter(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (order['status'] != 'Dispatched')
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () => _controller.advanceStatus(index),
                  child: Text(
                    actionButtonText,
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}