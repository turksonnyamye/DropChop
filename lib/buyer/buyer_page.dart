import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_controller.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({super.key});

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
  int _currentIndex = 0;
  final List<CentralFoodItem> _cart = [];
  final DropChopStateController _stateController = DropChopStateController();

  final List<CentralFoodItem> _foodMenu = [
    CentralFoodItem(id: '1', name: 'Deluxe Beef Burger', vendor: 'Burger King Express', price: 60.00, emoji: '🍔', category: 'Burgers'),
    CentralFoodItem(id: '2', name: 'Crunchy Chicken Wings', vendor: 'KFC East Legon', price: 45.00, emoji: '🍗', category: 'Chicken'),
    CentralFoodItem(id: '3', name: 'Accra Jollof & Chicken', vendor: 'Ghanaian Kitchen', price: 55.00, emoji: '🍛', category: 'Local'),
    CentralFoodItem(id: '4', name: 'Oreo Thick Milkshake', vendor: 'Burger King Express', price: 25.00, emoji: '🥤', category: 'Drinks'),
  ];

  @override
  void initState() {
    super.initState();
    _stateController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      _buildCartTab(),
      _buildOrdersTab(),
      _buildProfileTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF32BB78),
          unselectedItemColor: Colors.grey.shade400,
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_rounded), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Bag'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Live Orders'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DELIVER TO', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Color(0xFF32BB78), size: 18),
                      const SizedBox(width: 4),
                      Text('East Legon, Accra', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: const Icon(Icons.notifications_none_rounded, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text("Accra's Finest\nGastronomy", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w900, height: 1.2)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _foodMenu.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, idx) {
                final item = _foodMenu[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: const Color(0xFFF5F6F8), borderRadius: BorderRadius.circular(16)),
                          child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 38))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(item.vendor, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 8),
                              Text('GHS ${item.price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 15, color: const Color(0xFF32BB78))),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _cart.add(item);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} added to cart!'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: const Color(0xFF32BB78),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF32BB78),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          child: Text('Add', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    double subtotal = _cart.fold(0, (sum, item) => sum + item.price);
    double deliveryFee = _cart.isEmpty ? 0.0 : 12.0;
    double total = subtotal + deliveryFee;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('My Checkout Bag', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Expanded(
            child: _cart.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('Your bag is empty', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _cart.length,
                    itemBuilder: (context, idx) {
                      final item = _cart[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Text(item.emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                                  Text('GHS ${item.price.toStringAsFixed(2)}', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                              onPressed: () => setState(() => _cart.removeAt(idx)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_cart.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Subtotal', style: GoogleFonts.inter(color: Colors.grey)), Text('GHS ${subtotal.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.bold))]),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Delivery Fee', style: GoogleFonts.inter(color: Colors.grey)), Text('GHS ${deliveryFee.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.bold))]),
                  const Divider(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total Amount', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)), Text('GHS ${total.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18, color: const Color(0xFF32BB78)))]),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        _stateController.placeOrder(_cart, total, 'Hostel Block C, Legon Campus');
                        setState(() {
                          _cart.clear();
                          _currentIndex = 2; // Route to Orders Status Tab
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32BB78), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: Text('Confirm & Checkout', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
          ]
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final activeOrders = _stateController.orders;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Live Food Pipelines', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Expanded(
            child: activeOrders.isEmpty
                ? Center(child: Text('No ongoing orders.', style: GoogleFonts.inter(color: Colors.grey)))
                : ListView.builder(
                    itemCount: activeOrders.length,
                    itemBuilder: (context, idx) {
                      final order = activeOrders[idx];
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
                                Text('Order #${order.id}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 15)),
                                _buildStatusBadge(order.status),
                              ],
                            ),
                            const Divider(height: 24),
                            Text(order.vendorName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 6),
                            ...order.items.map((it) => Text('• ${it.name}', style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13))),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Paid', style: GoogleFonts.inter(color: Colors.grey, fontSize: 13)),
                                Text('GHS ${order.total.toStringAsFixed(2)}', style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFF32BB78))),
                              ],
                            )
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

  Widget _buildStatusBadge(OrderState status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case OrderState.placed:
        bg = Colors.amber.shade50;
        text = Colors.amber.shade800;
        label = 'PLACED';
        break;
      case OrderState.preparing:
        bg = Colors.blue.shade50;
        text = Colors.blue.shade800;
        label = 'KITCHEN';
        break;
      case OrderState.readyForPickup:
        bg = Colors.purple.shade50;
        text = Colors.purple.shade800;
        label = 'READY';
        break;
      case OrderState.enRoute:
        bg = Colors.orange.shade50;
        text = Colors.orange.shade800;
        label = 'DELIVERING';
        break;
      case OrderState.delivered:
        bg = Colors.green.shade50;
        text = Colors.green.shade800;
        label = 'ARRIVED';
        break;
      case OrderState.cancelled:
        bg = Colors.red.shade50;
        text = Colors.red.shade800;
        label = 'CANCELLED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: text)),
    );
  }

  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        const Center(
          child: Column(
            children: [
              CircleAvatar(radius: 46, backgroundColor: Color(0xFF32BB78), child: Icon(Icons.person, size: 46, color: Colors.white)),
              SizedBox(height: 12),
              Text('Adwoa Mensah', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('adwoa.mensah@gmail.com', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Color(0xFF32BB78)),
          title: const Text('Help & Support'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Sign Out'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/welcome');
          },
        ),
      ],
    );
  }
}