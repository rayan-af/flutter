import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/order_model.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'package:intl/intl.dart';

class ChefOrdersScreen extends StatefulWidget {
  const ChefOrdersScreen({super.key});

  @override
  State<ChefOrdersScreen> createState() => _ChefOrdersScreenState();
}

class _ChefOrdersScreenState extends State<ChefOrdersScreen> {
  // Update UI every minute to refresh the "X mins ago" text
  late final Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerStream = Stream.periodic(const Duration(minutes: 1), (x) => x);
  }

  void _markOrderDone(String orderId) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': 'done',
    });
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes == 0) return "Just now";
    if (difference.inHours > 0) return "\${difference.inHours}h \${difference.inMinutes % 60}m ago";
    return "\${difference.inMinutes} mins ago";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Orders"),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'pending')
            .orderBy('createdAt', descending: false) // Oldest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text("All caught up!", style: theme.textTheme.headlineSmall),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 220,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final order = OrderModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

              return GestureDetector(
                onDoubleTap: () => _markOrderDone(order.id),
                child: StreamBuilder(
                  stream: _timerStream,
                  builder: (context, _) {
                    final timeAgo = _getTimeAgo(order.createdAt);
                    final isUrgent = DateTime.now().difference(order.createdAt).inMinutes > 15;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isUrgent ? Colors.red.withValues(alpha: 0.5) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "#\${order.id.substring(order.id.length - 4)}",
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isUrgent ? Colors.red.shade100 : theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    timeAgo,
                                    style: TextStyle(
                                      color: isUrgent ? Colors.red.shade900 : theme.colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),
                            Expanded(
                              child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                itemCount: order.items.length,
                                itemBuilder: (ctx, i) {
                                  final item = order.items[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("\${item.quantity}x", style: const TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.dish.name,
                                            style: const TextStyle(fontSize: 15),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                "Double-tap to mark done",
                                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              );
            },
          );
        },
      ),
    );
  }
}
