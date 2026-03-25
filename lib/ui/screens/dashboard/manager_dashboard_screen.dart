import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../widgets/custom_drawer.dart';
import '../inventory/inventory_screen.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // Slate Dark Professional Palette
  final Color bgDark = const Color(0xFF0F172A);
  final Color surfaceDark = const Color(0xFF1E293B);
  final Color textPrimary = Colors.white;
  final Color textSecondary = const Color(0xFF94A3B8);
  final Color electricBlue = const Color(0xFF0EA5E9);
  final Color tealAccent = const Color(0xFF14B8A6);
  final Color warningRose = const Color(0xFFF43F5E);
  final Color warningOrange = const Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    List<dynamic> lowStockItems = inventoryProvider.lowStockItems;
    int totalItems = inventoryProvider.items.length;
    double healthPercent = totalItems == 0 ? 0.0 : ((totalItems - lowStockItems.length) / totalItems) * 100;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgDark,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Intelligence Dashboard', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: textPrimary)),
        backgroundColor: bgDark,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: surfaceDark,
              child: Icon(Icons.person, color: electricBlue),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getOrdersStream(),
        builder: (context, ordersSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getWasteLogsStream(),
            builder: (context, wasteSnapshot) {
              
              final ordersDocs = ordersSnapshot.data?.docs ?? [];
              final wasteDocs = wasteSnapshot.data?.docs ?? [];
              
              double dailySales = _calculateDailySales(ordersDocs);
              int activeOrders = _calculateActiveOrders(ordersDocs);
              double wasteLoss = _calculateWasteLoss(wasteDocs);
              
              List<LiveActivity> activityFeed = _buildActivityFeed(ordersDocs, wasteDocs);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (lowStockItems.isNotEmpty)
                      _buildPriorityAlert(lowStockItems)
                          .animate().fade(duration: 400.ms).slideY(begin: -0.1),
                    if (lowStockItems.isNotEmpty) const SizedBox(height: 24),
                    
                    Text('KEY METRICS', style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _buildMetricsGrid(dailySales, activeOrders, wasteLoss, healthPercent)
                        .animate().fade(duration: 500.ms).slideY(begin: 0.1),
                    
                    const SizedBox(height: 32),
                    Text('LIVE ACTIVITY FEED', style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const SizedBox(height: 16),
                    _buildActivityFeedList(activityFeed)
                        .animate(delay: 200.ms).fade(duration: 500.ms).slideY(begin: 0.1),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }

  Widget _buildPriorityAlert(List<dynamic> lowStockItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warningRose.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warningRose.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: warningRose, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CRITICAL: LOW STOCK', style: TextStyle(color: warningRose, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('${lowStockItems.length} items have dropped below their minimum threshold.', style: TextStyle(color: warningRose.withOpacity(0.9), fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InventoryScreen(isReadOnly: false))),
            style: ElevatedButton.styleFrom(backgroundColor: warningRose, foregroundColor: Colors.white),
            child: const Text('Resolve'),
          )
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(double sales, int activeOrders, double waste, double health) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildMetricTile('Daily Sales', '\$${sales.toStringAsFixed(2)}', Icons.payments_rounded, electricBlue),
        _buildMetricTile('Active Orders', '$activeOrders', Icons.room_service_rounded, warningOrange),
        _buildMetricTile('Waste Loss (7d)', '\$${waste.toStringAsFixed(2)}', Icons.delete_sweep_rounded, warningRose),
        _buildMetricTile('Inventory Health', '${health.toStringAsFixed(1)}%', Icons.health_and_safety_rounded, tealAccent),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              Icon(icon, color: accent.withOpacity(0.8), size: 20),
            ],
          ),
          Text(value, style: TextStyle(color: textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActivityFeedList(List<LiveActivity> activities) {
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: surfaceDark, borderRadius: BorderRadius.circular(16)),
        child: Text('No recent activity recorded.', style: TextStyle(color: textSecondary)),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.05), height: 1),
        itemBuilder: (context, index) {
          final act = activities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: act.color.withOpacity(0.15),
              child: Icon(act.icon, color: act.color, size: 20),
            ),
            title: Text(act.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(act.subtitle, style: TextStyle(color: textSecondary, fontSize: 12)),
            trailing: Text(_formatTime(act.timestamp), style: TextStyle(color: textSecondary, fontSize: 12)),
          );
        },
      ),
    );
  }

  // --- Data Logic Helpers ---
  double _calculateDailySales(List<QueryDocumentSnapshot> docs) {
    double sum = 0;
    final now = DateTime.now();
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null) {
        final date = ts.toDate();
        if (date.year == now.year && date.month == now.month && date.day == now.day) {
          sum += (data['total'] as num?)?.toDouble() ?? 0.0;
        }
      }
    }
    return sum;
  }

  int _calculateActiveOrders(List<QueryDocumentSnapshot> docs) {
    int count = 0;
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final status = data['status'] as String?;
      if (status == 'pending' || status == 'preparing') count++;
    }
    return count;
  }

  double _calculateWasteLoss(List<QueryDocumentSnapshot> docs) {
    double sum = 0;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null && ts.toDate().isAfter(weekAgo)) {
        sum += (data['cost_lost'] as num?)?.toDouble() ?? 0.0;
      }
    }
    return sum;
  }

  List<LiveActivity> _buildActivityFeed(List<QueryDocumentSnapshot> orders, List<QueryDocumentSnapshot> wastes) {
    List<LiveActivity> feed = [];
    
    // Add Orders
    for (var doc in orders) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null) {
        final total = (data['total'] as num?)?.toDouble() ?? 0.0;
        feed.add(LiveActivity(
          'New Order Created',
          'Total: \$${total.toStringAsFixed(2)} | Status: ${data['status'] ?? 'completed'}',
          ts.toDate(),
          Icons.receipt_long_rounded,
          electricBlue,
        ));
      }
    }
    
    // Add Waste
    for (var doc in wastes) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null) {
        final cost = (data['cost_lost'] as num?)?.toDouble() ?? 0.0;
        final qty = data['quantity'] ?? 0;
        feed.add(LiveActivity(
          'Waste Logged',
          'Lost \$${cost.toStringAsFixed(2)} | Qty: $qty | Reason: ${data['reason']}',
          ts.toDate(),
          Icons.delete_outline,
          warningRose,
        ));
      }
    }
    
    // Sort and Take Top 10
    feed.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return feed.take(10).toList();
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }
}

class LiveActivity {
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final Color color;

  LiveActivity(this.title, this.subtitle, this.timestamp, this.icon, this.color);
}
