import 'package:flutter/material.dart';

class VendorOrderController extends ChangeNotifier {
  // Shared static database tracker of live merchant pipelines
  static final List<Map<String, dynamic>> _sharedOrders = [
    {
      'id': '2019',
      'clientName': 'Jessica K.',
      'items': ['2x Deluxe Beef Burgers', '1x Large Fries', '1x Oreo Milkshake'],
      'status': 'Accepted', // Status cycle: Accepted -> Preparing -> Ready for Pickup -> Dispatched
      'assignedRider': 'Alex Rider Fleet',
      'riderRating': '4.92 ★',
      'timestamp': 'Just now',
      'calculatedPrep': '16 mins', // Dynamic Base (10 mins) + 2 mins * items (3) = 16 mins
      'totalPrice': 120.00,
    },
    {
      'id': '8842',
      'clientName': 'Marcus T.',
      'items': ['1x Family Feast Bucket', '2x Spicy Zinger Burgers', '1x Large Coleslaw'],
      'status': 'Preparing',
      'assignedRider': 'Alex Rider Fleet',
      'riderRating': '4.92 ★',
      'timestamp': '8 mins ago',
      'calculatedPrep': '18 mins', // Base (10 mins) + 2 mins * items (4) = 18 mins
      'totalPrice': 240.00,
    },
  ];

  // Dynamic status/parameters set by Module 3 (Capacity control)
  static bool isBusyModeActive = false;
  static double platformCommissionRate = 0.25; // Standard platform commission default (25%)

  List<Map<String, dynamic>> get orders => _sharedOrders;

  // Module 1 Dynamic preparation calculation formula
  String calculateOperationalPrepTime(int itemCount) {
    int baseMinutes = 10;
    int perItemMinutes = 2;
    int volumeBuffer = _sharedOrders.where((o) => o['status'] != 'Dispatched').length > 5 ? 5 : 0;
    int busyModeBuffer = isBusyModeActive ? 15 : 0;

    int computedMinutes = baseMinutes + (perItemMinutes * itemCount) + volumeBuffer + busyModeBuffer;
    return "$computedMinutes mins";
  }

  // Live order acceptance hook containing automatic calculations
  void addNewIncomingOrder({
    required String id,
    required String clientName,
    required List<String> items,
    required double totalPrice,
    String? rider,
  }) {
    final computedPrep = calculateOperationalPrepTime(items.length);
    
    _sharedOrders.insert(0, {
      'id': id,
      'clientName': clientName,
      'items': items,
      'status': 'Accepted',
      'assignedRider': rider ?? 'Assigning Courier...',
      'riderRating': 'New ★',
      'timestamp': 'Just now',
      'calculatedPrep': computedPrep,
      'totalPrice': totalPrice,
    });
    
    notifyListeners();
  }

  // Module 4: Calculate net earnings minus commissions
  double getDailyNetPayouts() {
    double grossSales = _sharedOrders
        .where((o) => o['status'] == 'Dispatched')
        .fold(0.0, (sum, order) => sum + (order['totalPrice'] as double));
    return grossSales * (1 - platformCommissionRate);
  }

  // Advances the kitchen workflow lifecycle state
  void advanceStatus(int index) {
    String currentStatus = _sharedOrders[index]['status'];
    
    if (currentStatus == 'Accepted') {
      _sharedOrders[index]['status'] = 'Preparing';
    } else if (currentStatus == 'Preparing') {
      _sharedOrders[index]['status'] = 'Ready for Pickup';
    } else if (currentStatus == 'Ready for Pickup') {
      _sharedOrders[index]['status'] = 'Dispatched';
    }
    notifyListeners();
  }
}