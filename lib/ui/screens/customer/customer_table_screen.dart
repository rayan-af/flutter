import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerTableScreen extends StatefulWidget {
  final String tableId;

  const CustomerTableScreen({super.key, required this.tableId});

  @override
  State<CustomerTableScreen> createState() => _CustomerTableScreenState();
}

class _CustomerTableScreenState extends State<CustomerTableScreen> {
  bool _isSeated = false;

  @override
  void initState() {
    super.initState();
    _seatTable();
  }

  Future<void> _seatTable() async {
    try {
      await FirebaseFirestore.instance.collection('tables').doc(widget.tableId).set({
        'isOccupied': true,
        'foodStatus': 'Waiting to Order',
        'activeSince': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      if (mounted) {
        setState(() {
          _isSeated = true;
        });
      }
    } catch (e) {
      debugPrint('Error seating table: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.terrain_rounded,
                      size: 90,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome to RestoManager!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Table ${widget.tableId}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                if (_isSeated) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your waiter has been notified.\nPlease wait a moment to order.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to digital menu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Digital Menu coming soon!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View Menu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Seating you...'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
