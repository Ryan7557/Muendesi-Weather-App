import 'package:flutter/material.dart';

class ErrorWidgetWarning extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final bool isDarkMode;

  const ErrorWidgetWarning({
    Key? key,
    required this.error,
    required this.onRetry,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: isDarkMode ? Colors.white70 : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}