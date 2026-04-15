import 'package:flutter/material.dart';
import '../screens/subscription_screen.dart';

class ProLockOverlay extends StatelessWidget {
  final Widget child;
  final bool isPro;

  const ProLockOverlay({Key? key, required this.child, required this.isPro})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPro) return child;

    return Stack(
      children: [
        child,
        Container(
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 48, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  '专业版功能',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SubscriptionScreen()),
                    );
                  },
                  child: Text('立即解锁'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
