import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryStepper extends StatelessWidget {
  final String currentStep;

  const DeliveryStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    int activeIndex = 0;
    if (currentStep == 'Picking Up Order') activeIndex = 1;
    if (currentStep == 'En Route to Customer') activeIndex = 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepNode('Vendor', activeIndex >= 0, activeIndex == 0),
          _buildLine(activeIndex >= 1),
          _buildStepNode('Collect', activeIndex >= 1, activeIndex == 1),
          _buildLine(activeIndex >= 2),
          _buildStepNode('Client', activeIndex >= 2, activeIndex == 2),
        ],
      ),
    );
  }

  Widget _buildStepNode(String label, bool isDone, bool isCurrent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrent 
                ? const Color(0xFF32BB78) 
                : (isDone ? const Color(0xFFE8F8F0) : Colors.grey.shade100),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCurrent ? Icons.directions_bike : (isDone ? Icons.check : Icons.radio_button_off),
            color: isCurrent ? Colors.white : (isDone ? const Color(0xFF32BB78) : Colors.grey),
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11, 
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
            color: isCurrent ? Colors.black : Colors.grey.shade600
          ),
        )
      ],
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 3,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF32BB78) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}