import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/order_item_card.dart';
import '../widgets/delivery_stepper.dart';

class AvailableOrdersScreen extends StatefulWidget {
  final List<Map<String, String>> availableJobs;
  final Map<String, String>? ongoingJob;
  final String currentDeliveryStep;
  final Function(Map<String, String>) onAcceptJob;
  final VoidCallback onAdvanceStep;

  const AvailableOrdersScreen({
    super.key,
    required this.availableJobs,
    required this.ongoingJob,
    required this.currentDeliveryStep,
    required this.onAcceptJob,
    required this.onAdvanceStep,
  });

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  double _dragPosition = 0.0;
  bool _isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. MAP VIEW SURFACE 
          Container(
            color: const Color(0xFFF0F4F8), 
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: MapRoadsPainter(hasActiveRoute: widget.ongoingJob != null),
              child: Stack(
                children: [
                  if (widget.ongoingJob != null) ...[
                    const Positioned(
                      top: 240,
                      left: 90,
                      child: MapPinBadge(
                        icon: Icons.store_rounded,
                        backgroundColor: Colors.black,
                        label: "Vendor Hub",
                      ),
                    ),
                    const Positioned(
                      top: 420,
                      right: 90,
                      child: MapPinBadge(
                        icon: Icons.person_pin_circle_rounded,
                        backgroundColor: Color(0xFF32BB78),
                        label: "Drop Destination",
                      ),
                    ),
                    _buildAnimatedRiderPosition(),
                  ],
                ],
              ),
            ),
          ),

          // 2. GLASSMORPHIC STEPPER HEADER OVERLAY
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: widget.ongoingJob == null 
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.radar, color: Color(0xFF32BB78)),
                        const SizedBox(width: 12),
                        Text('Radar Active • Auto Matching Open', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )
                : DeliveryStepper(currentStep: widget.currentDeliveryStep),
          ),

          // 3. SLIDING BOTTOM SYSTEM PANEL
          DraggableScrollableSheet(
            initialChildSize: widget.ongoingJob != null ? 0.38 : 0.45,
            minChildSize: 0.20,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 40, spreadRadius: 4)],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  children: [
                    Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 24),
                    if (widget.ongoingJob != null) ...[
                      _buildAdvancedPanel(widget.ongoingJob!)
                    ] else ...[
                      Text('Live Pipeline Offers', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 16),
                      ...widget.availableJobs.map((job) => OrderItemCard(
                            orderId: job['id']!,
                            pickupLocation: job['pickup']!,
                            dropLocation: job['drop']!,
                            payout: '\$${job['payout']}',
                            actionLabel: 'Lock In Run Route',
                            onActionPressed: () => widget.onAcceptJob(job),
                          )),
                    ]
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildAnimatedRiderPosition() {
    double topPos = 300; double leftPos = 130;
    if (widget.currentDeliveryStep == 'Picking Up Order') { topPos = 250; leftPos = 105; }
    if (widget.currentDeliveryStep == 'En Route to Customer') { topPos = 370; leftPos = 210; }

    return Positioned(
      top: topPos,
      left: leftPos,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF32BB78), 
          shape: BoxShape.circle, 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
        ),
        child: const Icon(Icons.navigation, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildAdvancedPanel(Map<String, String> job) {
    String trackLabelText = 'SWIPE TO CONFIRM ARRIVAL';
    if (widget.currentDeliveryStep == 'Picking Up Order') trackLabelText = 'SWIPE TO VERIFY COLLECTION';
    if (widget.currentDeliveryStep == 'En Route to Customer') trackLabelText = 'SWIPE TO COMPLETE DROP';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RUN IN PROGRESS', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey)),
                Text(job['vendorName'] ?? 'Vendor Outlet', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Text('\$${job['payout']}', style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w900, color: const Color(0xFF32BB78))),
          ],
        ),
        const Divider(height: 40),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.grey.shade400),
            const SizedBox(width: 12),
            Expanded(child: Text(job['drop']!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.grey.shade800))),
          ],
        ),
        const SizedBox(height: 32),

        // =====================================================================
        // PREMIUM CUSTOM GESTURE SLIDE BUTTON TRACK
        // =====================================================================
        LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth;
            double handleSize = 52.0;
            double maxDragDistance = maxWidth - handleSize - 8.0;

            return Container(
              width: maxWidth,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2229), // Deep premium slate/dark gray track
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Inner Track Banner Prompt Text
                  Center(
                    child: Text(
                      trackLabelText,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.45),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  // Dynamic Action Fill Background Effect
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    width: _dragPosition + handleSize,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF32BB78).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  // Interactive Drag Floating Thumb Handle
                  Positioned(
                    left: _dragPosition + 4.0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dragPosition += details.delta.dx;
                          if (_dragPosition < 0) _dragPosition = 0;
                          if (_dragPosition > maxDragDistance) _dragPosition = maxDragDistance;
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        if (_dragPosition >= maxDragDistance * 0.85) {
                          // Snapped past completion point threshold successfully
                          setState(() {
                            _dragPosition = maxDragDistance;
                            _isFinished = true;
                          });
                          widget.onAdvanceStep();
                          
                          // Smooth reset for next step
                          Future.delayed(const Duration(milliseconds: 300), () {
                            if (mounted) {
                              setState(() {
                                _dragPosition = 0.0;
                                _isFinished = false;
                              });
                            }
                          });
                        } else {
                          // Spring back snap recovery failure safeguard
                          setState(() {
                            _dragPosition = 0.0;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: _isFinished ? 150 : 0),
                        width: handleSize,
                        height: handleSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFF32BB78), // Smooth custom green handle
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF32BB78).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// Map Custom Components & Background Painters 
class MapPinBadge extends StatelessWidget {
  final IconData icon; final Color backgroundColor; final String label;
  const MapPinBadge({super.key, required this.icon, required this.backgroundColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ],
    );
  }
}

class MapRoadsPainter extends CustomPainter {
  final bool hasActiveRoute;
  MapRoadsPainter({required this.hasActiveRoute});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 20..strokeCap = StrokeCap.round;
    final borderPaint = Paint()..color = Colors.grey.shade200..style = PaintingStyle.stroke..strokeWidth = 24..strokeCap = StrokeCap.round;

    List<Path> mapPaths = [
      Path()..moveTo(0, 280)..lineTo(size.width, 280),
      Path()..moveTo(110, 0)..lineTo(110, size.height),
      Path()..moveTo(size.width - 110, 0)..lineTo(size.width - 110, size.height),
      Path()..moveTo(0, 460)..lineTo(size.width, 460),
    ];

    for (var path in mapPaths) { canvas.drawPath(path, borderPaint); canvas.drawPath(path, roadPaint); }

    if (hasActiveRoute) {
      final routePaint = Paint()..color = const Color(0xFF32BB78)..style = PaintingStyle.stroke..strokeWidth = 10..strokeCap = StrokeCap.round;
      final Path dynamicRoute = Path()..moveTo(110, 280)..lineTo(110, 460)..lineTo(size.width - 110, 460);
      canvas.drawPath(dynamicRoute, routePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}