import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/role_shell.dart';

// Live stream provider for local preview without Firebase rules
final kitchenOrdersProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) async* {
  // Yield mock data immediately so UI doesn't hang
  yield [
    {
      'id': 'ord_1',
      'tableNumber': '3',
      'orderId': '1042',
      'status': 'In Kitchen',
      'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 12))),
      'items': [
        {'name': 'Wagyu Beef Burger', 'quantity': 1},
        {'name': 'Truffle Parmesan Fries', 'quantity': 1},
      ],
    },
    {
      'id': 'ord_2',
      'tableNumber': '8',
      'orderId': '1043',
      'status': 'In Kitchen',
      'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 5))),
      'items': [
        {'name': 'Chicken Alfredo', 'quantity': 2},
        {'name': 'Classic Tiramisu', 'quantity': 1},
      ],
    },
    {
      'id': 'ord_3',
      'tableNumber': '5',
      'orderId': '1044',
      'status': 'In Kitchen',
      'timestamp': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 1))),
      'items': [
        {'name': 'Spicy Mango Margarita', 'quantity': 3},
        {'name': 'Texas Cheese Fries', 'quantity': 1},
      ],
    },
  ];

  try {
    await for (final snapshot in FirebaseFirestore.instance.collection('orders').where('status', isEqualTo: 'In Kitchen').snapshots()) {
      if (snapshot.docs.isNotEmpty) {
        yield snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            ...data,
          };
        }).toList();
      }
    }
  } catch (_) {
    // If it fails, it will just keep the mock data that was already yielded
  }
});

// Pillar 1: Move business logic to Riverpod Provider
final chefControllerProvider = Provider<ChefController>((ref) => ChefController());

class ChefController {
  Future<void> markOrderReady(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(data['id'])
        .set({'status': 'Ready to Serve'}, SetOptions(merge: true));
    
    final tableNum = data['tableNumber'];
    if (tableNum != null && tableNum.toString().isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('tables')
          .doc(tableNum.toString())
          .set({
        'foodStatus': 'Ready to Serve',
      }, SetOptions(merge: true));
    }
  }
}

class ChefScreen extends ConsumerWidget {
  const ChefScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsyncValue = ref.watch(kitchenOrdersProvider);

    return RoleScaffold(
      title: 'Chef Kitchen',
      subtitle: '',
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildFilterPill('All Active', true),
                  const SizedBox(width: 8),
                  _buildFilterPill('Grill Only', false),
                  const SizedBox(width: 8),
                  _buildFilterPill('Fryer Only', false),
                ],
              ),
            ),
            Expanded(
              child: ordersAsyncValue.when(
                data: (docs) {
                  if (docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders in the kitchen.',
                        style: TextStyle(color: BistroPalette.muted),
                      ),
                    );
                  }

                  final sortedDocs = docs.toList();
                  sortedDocs.sort((a, b) {
                    final aTime = a['timestamp'] as Timestamp?;
                    final bTime = b['timestamp'] as Timestamp?;
                    if (aTime == null && bTime == null) return 0;
                    if (aTime == null) return 1;
                    if (bTime == null) return -1;
                    return aTime.compareTo(bTime);
                  });

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: sortedDocs.length,
                          itemBuilder: (context, index) {
                            return OrderCard(orderDoc: sortedDocs[index]);
                          },
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                        itemCount: sortedDocs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OrderCard(orderDoc: sortedDocs[index]),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: BistroPalette.orange)),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 16),
                      Text('Sync Error: $error', style: const TextStyle(color: BistroPalette.ink)),
                      ElevatedButton(
                        onPressed: () => ref.refresh(kitchenOrdersProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? BistroPalette.black : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? BistroPalette.black : BistroPalette.line),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : BistroPalette.ink,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class OrderCard extends ConsumerWidget {
  final Map<String, dynamic> orderDoc;

  const OrderCard({super.key, required this.orderDoc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = orderDoc;
    final tableNumber = data['tableNumber'] ?? 'N/A';
    final orderId = data['orderId'] ?? data['id'];
    final timestamp = data['timestamp'] as Timestamp?;
    final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

    return BistroCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tbl $tableNumber', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BistroPalette.ink)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: BistroPalette.muted),
                      const SizedBox(width: 4),
                      Text('Server: Alex \u2022 4 Guests', style: const TextStyle(fontSize: 10, color: BistroPalette.muted, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              if (timestamp != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DynamicTimerText(timestamp: timestamp),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: BistroPalette.redSoft, borderRadius: BorderRadius.circular(4)),
                      child: const Text('LATE', style: TextStyle(color: BistroPalette.red, fontSize: 10, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 2, color: BistroPalette.red),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 24, color: BistroPalette.line),
              itemBuilder: (context, index) {
                final item = items[index];
                final itemName = item['name'] ?? 'Unknown Item';
                final quantity = item['quantity'] ?? 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BistroPalette.ink)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: BistroPalette.ink)),
                          const SizedBox(height: 4),
                          if (index == 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: BistroPalette.redSoft, borderRadius: BorderRadius.circular(4)),
                              child: const Text('ALLERGY: NO GARLIC', style: TextStyle(color: BistroPalette.red, fontSize: 10, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(height: 4),
                            const Text('Med Rare', style: TextStyle(color: BistroPalette.orange, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: BistroPalette.line, width: 2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: index == 1 ? const Icon(Icons.check, size: 20, color: BistroPalette.ink) : null,
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BistroPalette.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                try {
                  await ref.read(chefControllerProvider).markOrderReady(data);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order marked as ready!')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
                  }
                }
              },
              child: const Text('BUMP TICKET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 1.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicTimerText extends StatefulWidget {
  final Timestamp timestamp;

  const DynamicTimerText({super.key, required this.timestamp});

  @override
  State<DynamicTimerText> createState() => _DynamicTimerTextState();
}

class _DynamicTimerTextState extends State<DynamicTimerText> {
  late Timer _timer;
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final orderTime = widget.timestamp.toDate();
    final difference = now.difference(orderTime);

    final minutes = difference.inMinutes;
    final seconds = difference.inSeconds % 60;
    
    setState(() {
      _timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: BistroPalette.red,
      ),
    );
  }
}
