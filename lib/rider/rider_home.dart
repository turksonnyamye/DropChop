import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/rider_dashboard.dart';
import 'screens/available_orders.dart';
import 'screens/rider_profile.dart';
import 'widgets/vendor_details_sheet.dart'; // Import newly created file

class RiderHomePage extends StatefulWidget {
  const RiderHomePage({super.key});

  @override
  State<RiderHomePage> createState() => _RiderHomePageState();
}

class _RiderHomePageState extends State<RiderHomePage> {
  int _currentIndex = 1; // Opens default view to Map Run

  double _dailyEarnings = 0.00;
  int _completedTrips = 0;
  String _currentStepStatus = 'Available'; 
  Map<String, String>? _activeTripData;

  // Global ledger arrays mapping historical completions
  final List<Map<String, String>> _completionHistory = [];

  // Vendor profiles injected inside assignments schema
  final List<Map<String, String>> _jobsPool = [
    {
      'id': '2019', 
      'pickup': 'Burger King, Block B', 
      'drop': 'Suite 12, Diamond Estates', 
      'payout': '9.50',
      'vendorName': 'Burger King Express',
      'vendorRating': '4.5'
    },
    {
      'id': '8842', 
      'pickup': 'KFC, Galleria Mall', 
      'drop': '45 Cantonment Close', 
      'payout': '14.20',
      'vendorName': 'KFC Galleria',
      'vendorRating': '4.2'
    },
  ];

  void _acceptOfferConfirmation(Map<String, String> selectedJob) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 32, backgroundColor: Color(0xFF32BB78), child: Icon(Icons.flash_on, color: Colors.white, size: 36)),
                const SizedBox(height: 16),
                Text('Accept Dispatch?', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 16),
                Text('Vendor Match: ${selectedJob['vendorName']}', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32BB78)),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _jobsPool.removeWhere((item) => item['id'] == selectedJob['id']);
                            _activeTripData = selectedJob;
                            _currentStepStatus = 'Routing to Vendor';
                          });
                        },
                        child: const Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _advanceDeliveryStepEngine() {
    if (_currentStepStatus == 'Routing to Vendor') {
      // POP UP THE INTERACTIVE VENDOR INVENTORY CHECKLIST SHEET
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (context) => VendorDetailsSheet(
          job: _activeTripData!,
          onConfirmPickup: () {
            Navigator.pop(context); // Dismiss sheet
            setState(() => _currentStepStatus = 'En Route to Customer');
          },
        ),
      );
    } else if (_currentStepStatus == 'En Route to Customer') {
      final double earningsValue = double.parse(_activeTripData?['payout'] ?? '0.00');
      setState(() {
        _dailyEarnings += earningsValue;
        _completedTrips += 1;
        _completionHistory.add(_activeTripData!); // Feed dashboard history tracking
        _activeTripData = null;
        _currentStepStatus = 'Available';
        _currentIndex = 0; // Snap to stats view
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      RiderDashboardScreen(
        activeOrders: _activeTripData != null ? [_activeTripData!] : [],
        completedHistory: _completionHistory,
        dailyEarnings: _dailyEarnings,
        completedTrips: _completedTrips,
        onCompleteOrder: (_) {},
      ),
      AvailableOrdersScreen(
        availableJobs: _jobsPool,
        ongoingJob: _activeTripData,
        currentDeliveryStep: _currentStepStatus,
        onAcceptJob: _acceptOfferConfirmation,
        onAdvanceStep: _advanceDeliveryStepEngine,
      ),
      const RiderProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('DropChop Dispatch', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF32BB78),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map Run'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}