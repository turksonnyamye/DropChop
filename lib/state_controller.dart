import 'package:flutter/material.dart';

enum OrderState { placed, preparing, readyForPickup, enRoute, delivered, cancelled }

class CentralFoodItem {
  final String id;
  final String name;
  final String vendor;
  final double price;
  final String emoji;
  final String category;

  CentralFoodItem({
    required this.id,
    required this.name,
    required this.vendor,
    required this.price,
    required this.emoji,
    required this.category,
  });
}

class CentralOrder {
  final String id;
  final List<CentralFoodItem> items;
  OrderState status;
  final DateTime placedAt;
  final double total;
  final String vendorName;
  final String pickupLocation;
  final String dropoffLocation;
  String? assignedRider;
  String riderRating;
  String calculatedPrep;

  CentralOrder({
    required this.id,
    required this.items,
    required this.status,
    required this.placedAt,
    required this.total,
    required this.vendorName,
    required this.pickupLocation,
    required this.dropoffLocation,
    this.assignedRider,
    this.riderRating = '4.9 ★',
    this.calculatedPrep = '15 mins',
  });
}

class DropChopStateController extends ChangeNotifier {
  // Singleton Pattern
  static final DropChopStateController _instance = DropChopStateController._internal();
  factory DropChopStateController() => _instance;
  DropChopStateController._internal();

  // Unified Vendors
  final List<Map<String, String>> vendors = [
    {'name': 'Burger King Express', 'rating': '4.5', 'location': 'Burger King Express, Accra'},
    {'name': 'Ghanaian Kitchen', 'rating': '4.8', 'location': 'Ghanaian Kitchen, East Legon'},
    {'name': 'KFC East Legon', 'rating': '4.6', 'location': 'KFC East Legon, Accra'},
  ];

  // Dynamic order pipeline
  final List<CentralOrder> _orders = [
    CentralOrder(
      id: '2019',
      items: [
        CentralFoodItem(id: '1', name: 'Deluxe Beef Burger', vendor: 'Burger King Express', price: 60.00, emoji: '🍔', category: 'Burgers'),
        CentralFoodItem(id: '4', name: 'Oreo Thick Milkshake', vendor: 'Burger King Express', price: 25.00, emoji: '🥤', category: 'Drinks')
      ],
      status: OrderState.preparing,
      placedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      total: 97.00,
      vendorName: 'Burger King Express',
      pickupLocation: 'Burger King Express, Accra',
      dropoffLocation: 'Suite 12, Diamond Estates',
      assignedRider: 'Alex Rider Fleet',
    ),
  ];

  List<CentralOrder> get orders => _orders;

  // Statistics indicators
  double dailyEarnings = 0.0;
  int completedTrips = 0;

  // Place new order from Buyer page
  void placeOrder(List<CentralFoodItem> items, double total, String clientDropoff) {
    final String newId = (1000 + _orders.length + 1).toString();
    final String vendor = items.isNotEmpty ? items.first.vendor : 'Burger King Express';
    final String pickup = vendors.firstWhere((v) => v['name'] == vendor, orElse: () => {'location': 'Accra'})['location']!;

    final newOrder = CentralOrder(
      id: newId,
      items: List.from(items),
      status: OrderState.placed,
      placedAt: DateTime.now(),
      total: total,
      vendorName: vendor,
      pickupLocation: pickup,
      dropoffLocation: clientDropoff,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }

  // Advance state from Vendor page
  void advanceVendorStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index].status;
      if (current == OrderState.placed) {
        _orders[index].status = OrderState.preparing;
      } else if (current == OrderState.preparing) {
        _orders[index].status = OrderState.readyForPickup;
      }
      notifyListeners();
    }
  }

  // Rider accepts the order
  void assignRiderToOrder(String orderId, String riderName) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].assignedRider = riderName;
      _orders[index].status = OrderState.enRoute;
      notifyListeners();
    }
  }

  // Rider completes delivery step
  void completeOrder(String orderId, double payout) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = OrderState.delivered;
      dailyEarnings += payout;
      completedTrips += 1;
      notifyListeners();
    }
  }
}