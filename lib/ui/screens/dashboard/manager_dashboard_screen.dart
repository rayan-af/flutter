import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/services/firestore_service.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/role_shell.dart';
import '../inventory/inventory_screen.dart';
import '../../../l10n/app_localizations.dart';
import 'menu_editor_screen.dart';

// Top-level Riverpod providers for streams (Pillar 1 & 2)
final managerOrdersStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((
  ref,
) {
  return FirestoreService().getOrdersStream();
});

final managerWasteStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((
  ref,
) {
  return FirestoreService().getWasteLogsStream();
});

class ManagerDashboardScreen extends ConsumerStatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  ConsumerState<ManagerDashboardScreen> createState() =>
      _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState
    extends ConsumerState<ManagerDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color textPrimary = BistroPalette.ink;
  final Color textSecondary = BistroPalette.muted;
  final Color electricBlue = BistroPalette.orange;
  final Color tealAccent = BistroPalette.green;
  final Color warningRose = BistroPalette.red;
  final Color warningOrange = BistroPalette.amber;

  @override
  Widget build(BuildContext context) {
    // 1. Read inventory state safely via Riverpod
    final inventoryState = ref.watch(inventoryProvider);
    final lowStockItems =
        inventoryState.value
            ?.where((i) => i.quantity <= i.threshold)
            .toList() ??
        [];
    final totalItems = inventoryState.value?.length ?? 0;
    double healthPercent = totalItems == 0
        ? 0.0
        : ((totalItems - lowStockItems.length) / totalItems) * 100;

    final l10n = AppLocalizations.of(context)!;

    // 2. Watch multiple streams concurrently via Riverpod AsyncValues
    final ordersAsync = ref.watch(managerOrdersStreamProvider);
    final wasteAsync = ref.watch(managerWasteStreamProvider);

    return RoleScaffold(
      key: _scaffoldKey,
      title: 'Overview',
      subtitle: 'Today\'s operational metrics and insights.',
      body: ordersAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: electricBlue)),
        error: (err, stack) => Center(
          child: Text(
            "Error loading orders: $err",
            style: TextStyle(color: warningRose),
          ),
        ),
        data: (ordersSnapshot) {
          return wasteAsync.when(
            loading: () =>
                Center(child: CircularProgressIndicator(color: warningRose)),
            error: (err, stack) => Center(
              child: Text(
                "Error loading waste logs: $err",
                style: TextStyle(color: warningRose),
              ),
            ),
            data: (wasteSnapshot) {
              final ordersDocs = ordersSnapshot.docs;
              final wasteDocs = wasteSnapshot.docs;

              double dailySales = _calculateDailySales(ordersDocs);
              int activeOrders = _calculateActiveOrders(ordersDocs);
              double wasteLoss = _calculateWasteLoss(wasteDocs);

              List<LiveActivity> activityFeed = _buildActivityFeed(
                ordersDocs,
                wasteDocs,
                l10n,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Action Buttons Row
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.file_download_outlined, size: 16),
                            label: const Text('Export', style: TextStyle(fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: BistroPalette.ink,
                              side: const BorderSide(color: BistroPalette.line),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('New Shift', style: TextStyle(fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: BistroPalette.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildMainCards(dailySales, activeOrders),
                    
                    const SizedBox(height: 24),
                    const SectionLabel('Weekly Sales'),
                    const SizedBox(height: 12),
                    _buildWeeklySalesPlaceholder(),
                    
                    const SizedBox(height: 24),
                    const SectionLabel('Quick Links'),
                    const SizedBox(height: 12),
                    _buildQuickLinks(),
                    
                    const SizedBox(height: 24),
                    const SectionLabel('Alerts'),
                    const SizedBox(height: 12),
                    if (lowStockItems.isNotEmpty)
                      _buildPriorityAlert(lowStockItems, l10n),
                    
                    const SizedBox(height: 12),
                    _buildActivityFeedList(activityFeed, l10n),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildPriorityAlert(
    List<dynamic> lowStockItems,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BistroPalette.redSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: warningRose.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: warningRose, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lowStockAlert,
                  style: TextStyle(
                    color: warningRose,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.lowStockCount(lowStockItems.length),
                  style: TextStyle(
                    color: warningRose.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const InventoryScreen(isReadOnly: false),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: warningRose,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.resolve),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCards(double sales, int activeOrders) {
    return Column(
      children: [
        BistroCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today\'s Revenue', style: TextStyle(color: BistroPalette.ink, fontWeight: FontWeight.w600, fontSize: 13)),
                  Icon(Icons.payments, color: BistroPalette.green, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text('\$${sales.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: BistroPalette.ink)),
              const SizedBox(height: 4),
              const Text('+12.5% since yesterday', style: TextStyle(color: BistroPalette.green, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BistroCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Active Orders', style: TextStyle(color: BistroPalette.ink, fontWeight: FontWeight.w600, fontSize: 13)),
                  Icon(Icons.receipt_long, color: BistroPalette.orange, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text('$activeOrders', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BistroPalette.ink)),
              const SizedBox(height: 4),
              const Text('4 high priority', style: TextStyle(color: BistroPalette.red, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BistroCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Table Occupancy', style: TextStyle(color: BistroPalette.ink, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 12),
              const Text('78%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: BistroPalette.ink)),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.78,
                backgroundColor: BistroPalette.line,
                color: BistroPalette.ink,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BistroCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Staff On Shift', style: TextStyle(color: BistroPalette.ink, fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  const Text('12 / 15', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BistroPalette.ink)),
                ],
              ),
              const Icon(Icons.people_alt_outlined, color: BistroPalette.muted, size: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklySalesPlaceholder() {
    return BistroCard(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 120,
        alignment: Alignment.center,
        child: const Text('Chart Placeholder', style: TextStyle(color: BistroPalette.muted)),
      ),
    );
  }

  Widget _buildQuickLinks() {
    return BistroCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: BistroPalette.line, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.menu_book, color: BistroPalette.ink, size: 20),
            ),
            title: const Text('Menu Editor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('Update active dishes', style: TextStyle(fontSize: 12, color: BistroPalette.muted)),
            trailing: const Icon(Icons.chevron_right, color: BistroPalette.muted),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuEditorScreen()),
              );
            },
          ),
          const Divider(height: 1, color: BistroPalette.line),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: BistroPalette.line, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.analytics_outlined, color: BistroPalette.ink, size: 20),
            ),
            title: const Text('Reports', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: const Text('View deep analytics', style: TextStyle(fontSize: 12, color: BistroPalette.muted)),
            trailing: const Icon(Icons.chevron_right, color: BistroPalette.muted),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeedList(
    List<LiveActivity> activities,
    AppLocalizations l10n,
  ) {
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BistroPalette.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(l10n.noActivity, style: TextStyle(color: textSecondary)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: BistroPalette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BistroPalette.line),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (_, __) =>
            const Divider(color: BistroPalette.line, height: 1),
        itemBuilder: (context, index) {
          final act = activities[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: act.color.withOpacity(0.15),
              child: Icon(act.icon, color: act.color, size: 20),
            ),
            title: Text(
              act.title,
              style: TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              act.subtitle,
              style: TextStyle(color: textSecondary, fontSize: 12),
            ),
            trailing: Text(
              _formatTime(act.timestamp),
              style: TextStyle(color: textSecondary, fontSize: 12),
            ),
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
        if (date.year == now.year &&
            date.month == now.month &&
            date.day == now.day) {
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

  List<LiveActivity> _buildActivityFeed(
    List<QueryDocumentSnapshot> orders,
    List<QueryDocumentSnapshot> wastes,
    AppLocalizations l10n,
  ) {
    List<LiveActivity> feed = [];

    // Add Orders
    for (var doc in orders) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null) {
        final totalValue = (data['total'] as num?)?.toDouble() ?? 0.0;
        final statusValue = data['status'] ?? 'completed';
        feed.add(
          LiveActivity(
            l10n.newOrderActivity,
            '${l10n.total}: \$${totalValue.toStringAsFixed(2)} | ${l10n.status}: $statusValue',
            ts.toDate(),
            Icons.receipt_long_rounded,
            electricBlue,
          ),
        );
      }
    }

    // Add Waste
    for (var doc in wastes) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final ts = data['timestamp'] as Timestamp?;
      if (ts != null) {
        final costValue = (data['cost_lost'] as num?)?.toDouble() ?? 0.0;
        final qtyValue = data['quantity'] ?? 0;
        final reasonValue = data['reason'] ?? 'unknown';
        feed.add(
          LiveActivity(
            l10n.wasteLoggedActivity,
            '${l10n.lost}: \$${costValue.toStringAsFixed(2)} | ${l10n.qty}: $qtyValue | ${l10n.reason}: $reasonValue',
            ts.toDate(),
            Icons.delete_outline,
            warningRose,
          ),
        );
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

  LiveActivity(
    this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.color,
  );
}
