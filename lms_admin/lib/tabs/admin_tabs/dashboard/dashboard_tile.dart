import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  const DashboardTile({Key? key, required this.info, required this.count, required this.icon, this.bgColor}) : super(key: key);

  final String info;
  final int count;
  final IconData icon;
  final Color?  bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (bgColor ?? const Color(0xFF1c6ea4)).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: bgColor ?? const Color(0xFF1c6ea4),
                ),
              ),
              AnimatedFlipCounter(
                duration: const Duration(milliseconds: 800),
                value: count,
                thousandSeparator: ',',
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1a2851),
                  fontSize: 32,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            info,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.blueGrey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: bgColor ?? const Color(0xFF1c6ea4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
