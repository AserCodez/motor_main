import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 157,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7E9F3),
                  borderRadius: BorderRadius.circular(24), // Circular
                ),
                child: Icon(icon, color: const Color(0xFF263238), size: 24),
              ),
              const SizedBox(width: 16),
              // Header Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        height: 1.5, // 16.5 / 11
                        letterSpacing: 1.1,
                        color: Color(0xFF455A64),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        height: 1.5,
                        letterSpacing: 1.1,
                        color: Color(0xFF455A64),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Status Text
          Align(
            alignment: AlignmentGeometry.center,
            child: Text(
              status,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.55, // 28 / 18
                color: Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
