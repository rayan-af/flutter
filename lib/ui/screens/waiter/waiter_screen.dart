import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/role_shell.dart';
import 'waiter_pos_screen.dart';

// Live stream provider for Firestore
final tablesStreamProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) async* {
  // Yield mock data immediately so UI doesn't hang
  yield [
    {'id': '1', 'tableNumber': '1', 'isOccupied': true, 'foodStatus': 'Waiting to Order', 'activeSince': Timestamp.now()},
    {'id': '2', 'tableNumber': '2', 'isOccupied': false, 'foodStatus': 'N/A', 'activeSince': null},
    {'id': '3', 'tableNumber': '3', 'isOccupied': true, 'foodStatus': 'In Kitchen', 'activeSince': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 15)))},
    {'id': '4', 'tableNumber': '4', 'isOccupied': true, 'foodStatus': 'Ready to Serve', 'activeSince': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 25)))},
    {'id': '5', 'tableNumber': '5', 'isOccupied': false, 'foodStatus': 'N/A', 'activeSince': null},
    {'id': '6', 'tableNumber': '6', 'isOccupied': true, 'foodStatus': 'Served', 'activeSince': Timestamp.fromDate(DateTime.now().subtract(const Duration(minutes: 45)))},
  ];

  try {
    await for (final snapshot in FirebaseFirestore.instance.collection('tables').snapshots()) {
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
    // Fallback to the yielded mock data
  }
});

// Pillar 1: Move business logic to Riverpod Provider
final waiterControllerProvider = Provider<WaiterController>((ref) => WaiterController());

class WaiterController {
  Future<void> updateTable(Map<String, dynamic> tableDoc, bool isOccupied, String foodStatus) async {
    final updateData = <String, dynamic>{
      'isOccupied': isOccupied,
      'foodStatus': foodStatus,
    };

    if (isOccupied && tableDoc['activeSince'] == null) {
      updateData['activeSince'] = FieldValue.serverTimestamp();
    } else if (!isOccupied) {
      updateData['activeSince'] = FieldValue.delete();
      updateData['foodStatus'] = 'N/A';
    }

    await FirebaseFirestore.instance
        .collection('tables')
        .doc(tableDoc['id'])
        .set(updateData, SetOptions(merge: true));

    if (foodStatus == 'Served' || !isOccupied) {
      final tableNumStr = tableDoc['tableNumber']?.toString();
      if (tableNumStr != null && tableNumStr.isNotEmpty) {
        final activeOrdersSnapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('tableNumber', isEqualTo: tableNumStr)
            .get();

        final batch = FirebaseFirestore.instance.batch();
        bool hasUpdates = false;
        
        for (var doc in activeOrdersSnapshot.docs) {
          final currentStatus = doc.data()['status'];
          if (currentStatus != 'Served') {
            batch.update(doc.reference, {'status': 'Served'});
            hasUpdates = true;
          }
        }
        
        if (hasUpdates) {
          await batch.commit();
        }
      }
    }
  }
}


class WaiterScreen extends ConsumerWidget {
  const WaiterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsyncValue = ref.watch(tablesStreamProvider);

    return RoleScaffold(
      title: '',
      subtitle: '',
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  _buildLegendItem('Available', Colors.grey.shade300),
                  const SizedBox(width: 16),
                  _buildLegendItem('Occupied', BistroPalette.orange),
                  const SizedBox(width: 16),
                  _buildLegendItem('Needs Cleaning', BistroPalette.red),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Main Dining Floor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BistroPalette.ink),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tablesAsyncValue.when(
                data: (docs) {
                  if (docs.isEmpty) return const Center(child: Text('No tables.'));
                  final sortedDocs = docs.toList();
                  sortedDocs.sort((a, b) => (a['tableNumber']?.toString() ?? '').compareTo(b['tableNumber']?.toString() ?? ''));
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: sortedDocs.length,
                    itemBuilder: (context, index) => _buildGridCard(context, sortedDocs[index], index + 1),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: BistroPalette.orange)),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: BistroPalette.muted, letterSpacing: 0.5),
        ),
      ],
    );
  }

  DataRow _buildDataRow(BuildContext context, Map<String, dynamic> doc, int index) {
    final data = doc;
    final String tableNumber = index.toString();
    final isOccupied = data['isOccupied'] ?? false;
    final foodStatus = data['foodStatus'] ?? 'N/A';
    final activeSince = data['activeSince'] as Timestamp?;

    return DataRow(
      onSelectChanged: (_) => _showStatusUpdateModal(context, doc, index.toString()),
      cells: [
        DataCell(
          Text('Table $tableNumber', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: BistroPalette.ink)),
        ),
        DataCell(
          Row(
            children: [
              Icon(
                isOccupied ? Icons.restaurant : Icons.check_circle_outline,
                color: themeColor(isOccupied),
              ),
              const SizedBox(width: 8),
              Text(
                isOccupied ? 'Occupied' : 'Available',
                style: GoogleFonts.inter(color: themeColor(isOccupied), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        DataCell(
          Chip(
            label: Text(foodStatus, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12)),
            backgroundColor: _getFoodStatusColor(foodStatus).withOpacity(0.2),
            labelStyle: TextStyle(color: _getFoodStatusColor(foodStatus)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: BorderSide.none,
          ),
        ),
        DataCell(
          isOccupied && activeSince != null
              ? ActiveTimerText(timestamp: activeSince)
              : Text('-', style: GoogleFonts.inter(color: BistroPalette.muted)),
        ),
      ],
    );
  }

  Widget _buildGridCard(BuildContext context, Map<String, dynamic> doc, int index) {
    final data = doc;
    final String tableNumber = index.toString();
    final isOccupied = data['isOccupied'] ?? false;
    final foodStatus = data['foodStatus'] ?? 'N/A';
    final activeSince = data['activeSince'] as Timestamp?;
    
    final bgColor = isOccupied ? BistroPalette.orange : BistroPalette.surface;
    final textColor = isOccupied ? Colors.white : BistroPalette.ink;
    final subtitleColor = isOccupied ? Colors.white70 : BistroPalette.muted;

    return GestureDetector(
      onTap: () => _showStatusUpdateModal(context, doc, index.toString()),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isOccupied ? null : Border.all(color: BistroPalette.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'T$tableNumber',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.person_outline, color: subtitleColor, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOccupied ? 'Seated' : 'Available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 4),
                if (isOccupied && activeSince != null)
                  Text(
                    '45m ago \u2022 4 Guests',
                    style: TextStyle(fontSize: 11, color: subtitleColor, fontWeight: FontWeight.w500),
                  )
                else
                  Text('4 Seats', style: TextStyle(fontSize: 11, color: subtitleColor, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color themeColor(bool isOccupied) {
    return isOccupied ? BistroPalette.red : BistroPalette.green;
  }

  Color _getFoodStatusColor(String status) {
    switch (status) {
      case 'Waiting to Order':
        return BistroPalette.amber;
      case 'In Kitchen':
        return BistroPalette.orange;
      case 'Ready to Serve':
        return BistroPalette.green;
      case 'Served':
        return BistroPalette.muted;
      default:
        return BistroPalette.muted;
    }
  }

  void _showStatusUpdateModal(BuildContext context, Map<String, dynamic> doc, String displayTableNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BistroPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: TableActionModal(tableDoc: doc, displayTableNumber: displayTableNumber),
          ),
        );
      },
    );
  }
}

class TableActionModal extends ConsumerStatefulWidget {
  final Map<String, dynamic> tableDoc;
  final String displayTableNumber;

  const TableActionModal({super.key, required this.tableDoc, required this.displayTableNumber});

  @override
  ConsumerState<TableActionModal> createState() => _TableActionModalState();
}

class _TableActionModalState extends ConsumerState<TableActionModal> {
  late bool _isOccupied;
  late String _foodStatus;

  final List<String> _foodStatuses = [
    'Waiting to Order',
    'In Kitchen',
    'Ready to Serve',
    'Served',
    'N/A'
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.tableDoc;
    _isOccupied = data['isOccupied'] ?? false;
    _foodStatus = data['foodStatus'] ?? 'Waiting to Order';
  }

  Future<void> _updateTable() async {
    try {
      // Pillar 1: Delegate business logic to Riverpod Controller
      await ref.read(waiterControllerProvider).updateTable(widget.tableDoc, _isOccupied, _foodStatus);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update table: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Table ${widget.displayTableNumber}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: BistroPalette.ink),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Is Occupied?', style: TextStyle(color: BistroPalette.ink)),
            activeColor: BistroPalette.orange,
            value: _isOccupied,
            onChanged: (val) {
              setState(() {
                _isOccupied = val;
                if (!val) {
                  _foodStatus = 'N/A';
                } else if (_foodStatus == 'N/A') {
                  _foodStatus = 'Waiting to Order';
                }
              });
            },
          ),
          const SizedBox(height: 16),
          if (_isOccupied) ...[
            const Text('Food Status', style: TextStyle(fontWeight: FontWeight.bold, color: BistroPalette.ink)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              dropdownColor: BistroPalette.surface,
              style: const TextStyle(color: BistroPalette.ink, fontSize: 16),
              value: _foodStatuses.contains(_foodStatus) ? _foodStatus : 'N/A',
              items: _foodStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status, style: const TextStyle(color: BistroPalette.ink)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _foodStatus = val;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 24),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: BistroPalette.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: _updateTable,
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: BistroPalette.ink),
                foregroundColor: BistroPalette.ink,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaiterPOSScreen(tableNumber: widget.tableDoc['tableNumber'].toString())),
                );
              },
              child: const Text('Take Order (POS)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

class ActiveTimerText extends StatefulWidget {
  final Timestamp timestamp;

  const ActiveTimerText({super.key, required this.timestamp});

  @override
  State<ActiveTimerText> createState() => _ActiveTimerTextState();
}

class _ActiveTimerTextState extends State<ActiveTimerText> {
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
    final startTime = widget.timestamp.toDate();
    final difference = now.difference(startTime);

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    setState(() {
      if (hours > 0) {
        _timeString = '${hours}h ${minutes}m';
      } else {
        _timeString = '${minutes}m';
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.access_time, size: 16, color: BistroPalette.amber),
        const SizedBox(width: 4),
        Text(
          _timeString,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: BistroPalette.amber),
        ),
      ],
    );
  }
}
