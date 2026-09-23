import 'package:ditonton_core/common/constants.dart';
import 'package:flutter/material.dart';

class EmptyWatchlist extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyWatchlist({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 80, color: davysGrey),
          const SizedBox(height: 16),
          Text(title, style: heading6),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
