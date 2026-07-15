import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../state_controller.dart';

class VendorOrderManagerScreen extends StatefulWidget {
  const VendorOrderManagerScreen({super.key});

  @override
  State<VendorOrderManagerScreen> createState() => _VendorOrderManagerScreenState();
}

class _VendorOrderManagerScreenState extends State<VendorOrderManagerScreen> {
  final DropChopStateController _controller = DropChopStateController();
  String activeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveOrders = _controller.orders.where((o) {
      if (activeFilter == 'All') return o.status != OrderState.delivered;
      if (activeFilter == 'Preparing') return o.status == OrderState.preparing;
      if (activeFilter == 'Ready') return o.status == OrderState.readyForPickup;
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Kitchen Desk', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['All', 'Preparing', 'Ready'].map((f) {
              final isSel = activeFilter == f;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSel ? const Color(0xFF0EA37A) : Colors.white,
                  foregroundColor: isSel ? Colors.white : Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => setState(() => activeFilter = f),
                child: Text(f),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: liveOrders.isEmpty
                ? Center(child: Text('Kitchen queue cleared!', style: GoogleFonts.inter(color: Colors.grey)))
                : ListView.builder(
                    itemCount: liveOrders.length,
                    itemBuilder: (context, idx) {
                      final order = liveOrders[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order #${order.id}', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                Text('GHS ${order.total.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: const Color(0xFF0EA37A))),
                              ],
                            ),
                            const Divider(height: 24),
                            ...order.items.map((it) => Text('• ${it.name}')),
                            const Divider(height: 24),
                            if (order.status != OrderState.readyForPickup && order.status != OrderState.enRoute && order.status != OrderState.delivered)
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA37A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  onPressed: () => _controller.advanceVendorStatus(order.id),
                                  child: Text(order.status == OrderState.placed ? 'Accept & Cooking' : 'Mark Ready for Pickup', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              )
                            else
                              Text(order.status == OrderState.readyForPickup ? 'Waiting for Courier dispatch...' : 'En route to Client', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.amber.shade800))
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}