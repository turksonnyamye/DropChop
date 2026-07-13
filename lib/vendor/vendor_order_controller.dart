import 'package:flutter/material.dart';

class VendorOrderController extends ChangeNotifier {
  // Master database tracker of live merchant pipelines
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '2019',
      'clientName': 'Jessica K.',
      'items': ['2x Deluxe Beef Burgers', '1x Large Fries', '1x Oreo Milkshake'],
      'status': 'Accepted', // Accepted -> Preparing -> Ready for Pickup -> Dispatched
      'assignedRider': 'Alex Rider Fleet',
      'riderRating': '4.92 ★',
      'timestamp': 'Just now',
    },
    {
      'id': '8842',
      'clientName': 'Marcus T.',
      'items': ['1x Family Feast Bucket', '2x Spicy Zinger Burgers', '1x Large Coleslaw'],
      'status': 'Preparing',
      'assignedRider': 'Alex Rider Fleet',
      'riderRating': '4.92 ★',
      'timestamp': '8 mins ago',
    },
  ];

  List<Map<String, dynamic>> get orders => _orders;

  // Advances the kitchen workflow lifecycle state
  void advanceStatus(int index) {
    String currentStatus = _orders[index]['status'];
    
    if (currentStatus == 'Accepted') {
      _orders[index]['status'] = 'Preparing';
    } else if (currentStatus == 'Preparing') {
      _orders[index]['status'] = 'Ready for Pickup';
    } else if (currentStatus == 'Ready for Pickup') {
      _orders[index]['status'] = 'Dispatched';
    }
    
    notifyListeners(); // Force UI screens to refresh instantly
  }
}