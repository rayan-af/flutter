import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/role_shell.dart';
import '../../../core/models/reservation_models.dart';
import '../../../l10n/app_localizations.dart';

class TableMappingScreen extends StatefulWidget {
  const TableMappingScreen({super.key});

  @override
  State<TableMappingScreen> createState() => _TableMappingScreenState();
}

class _TableMappingScreenState extends State<TableMappingScreen> {
  int _selectedFloor = 0;
  // Floor names will be retrieved from l10n in build()

  late List<TableModel> _mapTables;

  @override
  void initState() {
    super.initState();
    // Initialize mock data uniquely for this session
    _mapTables = TableModel.mockTables.map((t) {
      TableStatus status = t.status;
      // Add visual variety based on mock IDs
      if (t.id == 2 || t.id == 5 || t.id == 8 || t.id == 21)
        status = TableStatus.reserved;
      if (t.id == 3 || t.id == 9 || t.id == 15 || t.id == 22)
        status = TableStatus
            .selected; // Using selected as 'Occupied' for visual difference
      return t.copyWith(status: status);
    }).toList();
  }

  void _onTableTapped(TableModel table) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  "${l10n.navTableMap.split(' ')[0]} ${table.label}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.seats(table.seats)),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusString(table.status, l10n),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Actions
                if (table.status == TableStatus.available) ...[
                  ElevatedButton(
                    onPressed: () {
                      _updateTable(table.id, TableStatus.selected); // Occupied
                      Navigator.pop(context);
                    },
                    child: Text(l10n.seatWalkIn),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      _updateTable(table.id, TableStatus.reserved);
                      Navigator.pop(context);
                    },
                    child: Text(l10n.markReserved),
                  ),
                ] else ...[
                  OutlinedButton(
                    onPressed: () {
                      _updateTable(table.id, TableStatus.available);
                      Navigator.pop(context);
                    },
                    child: Text(l10n.clearTableAvailable),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateTable(int id, TableStatus newStatus) {
    setState(() {
      final idx = _mapTables.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _mapTables[idx] = _mapTables[idx].copyWith(status: newStatus);
      }
    });
  }

  String _getStatusString(TableStatus status, AppLocalizations l10n) {
    if (status == TableStatus.available) return l10n.available;
    if (status == TableStatus.selected) return l10n.occupied;
    if (status == TableStatus.reserved) return l10n.reserved;
    return "Unknown";
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTableWidget(TableModel table) {
    final theme = Theme.of(context);
    final availableColor = theme.brightness == Brightness.dark ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surfaceVariant;
    final selectedColor = theme.colorScheme.secondary; 
    final reservedColor = theme.colorScheme.onSurface.withOpacity(0.4);
    
    Color tableColor;
    if (table.status == TableStatus.reserved) {
      tableColor = reservedColor;
    } else if (table.status == TableStatus.selected) {
      tableColor = selectedColor;
    } else {
      tableColor = availableColor;
    }

    return GestureDetector(
      onTap: () => _onTableTapped(table),
      child: Container(
        width: table.width.toDouble(),
        height: table.height.toDouble(),
        decoration: BoxDecoration(
          color: tableColor,
          shape: table.shape == TableShape.circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: table.shape == TableShape.rectangle ? BorderRadius.circular(8) : null,
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          boxShadow: [
            if (table.status != TableStatus.available)
               BoxShadow(color: tableColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)
          ],
        ),
        child: Center(
          child: Text(
            table.label,
            style: TextStyle(
              color: table.status == TableStatus.available 
                  ? theme.colorScheme.onSurface.withOpacity(0.6)
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloorPlan() {
    final theme = Theme.of(context);
    final tables = _mapTables.where((t) => t.floor == _selectedFloor).toList();
    
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InteractiveViewer(
          minScale: 0.1,
          maxScale: 2.0,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(200),
          child: SizedBox(
            width: 2200,
            height: 1500,
            child: Stack(
              children: tables.map((table) {
                return Positioned(
                  left: table.x.toDouble(),
                  top: table.y.toDouble(),
                  child: _buildTableWidget(table),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RoleScaffold(
      title: '',
      subtitle: '',
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Metrics Row 1
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Date', 'Oct 24', null),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Total Guests', '142', '+12', Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Top Metrics Row 2
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Parties', '8 Parties', null, null, Icons.people),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Waitlist', '45 / 80', null, BistroPalette.green, Icons.person_add),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Interactive Floor Plan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Floor Plan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: BistroPalette.black, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: const [
                        Text('Ground Floor', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFloorPlan(),
              
              const SizedBox(height: 32),
              
              // Reservations Timeline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reservations Timeline', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: BistroPalette.black, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: const [
                        Text('Upcoming', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildReservationItem('12:30', 'Smith Party', '4 Guests \u2022 Table 12 \u2022 VIP', true, true),
              _buildReservationItem('12:45', 'Jenkins', '2 Guests \u2022 Table 03', false, false, status: 'Seated', statusColor: BistroPalette.green),
              _buildReservationItem('13:15', 'Alvarez Group', '8 Guests \u2022 Unassigned', true, true, hasAssign: true, subtext: 'High chair needed'),
              
              const SizedBox(height: 32),
              
              // Live Waitlist
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Live Waitlist', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: BistroPalette.orangeSoft, borderRadius: BorderRadius.circular(16)),
                    child: const Text('6 Waiting', style: TextStyle(color: BistroPalette.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildWaitlistItem('Davis', '3 Guests \u2022 Walk-in', '25m wait'),
              _buildWaitlistItem('Chen', '2 Guests \u2022 Quote: 20m', '12m wait'),
              _buildWaitlistItem('O\'Connor', '4 Guests \u2022 Quote: 40m', '6m wait'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String? change, [Color? changeColor, IconData? icon]) {
    return BistroCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: BistroPalette.muted, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
              if (change != null) ...[
                const SizedBox(width: 8),
                Text(change, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: changeColor)),
              ],
              if (icon != null) ...[
                const Spacer(),
                Icon(icon, color: changeColor ?? BistroPalette.orange, size: 20),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationItem(String time, String name, String details, bool hasEdit, bool hasCheckIn, {String? status, Color? statusColor, bool hasAssign = false, String? subtext}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
                    if (status != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: statusColor?.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.w800)),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(details, style: const TextStyle(fontSize: 12, color: BistroPalette.muted, fontWeight: FontWeight.w500)),
                if (subtext != null) ...[
                  const SizedBox(height: 4),
                  Text('"$subtext"', style: const TextStyle(fontSize: 12, color: BistroPalette.muted, fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (hasEdit)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showMessage('Edit reservation tapped'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: BistroPalette.ink,
                            side: const BorderSide(color: BistroPalette.line),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    if (hasAssign) ...[
                      if (hasEdit) const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showMessage('Assign table tapped'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: BistroPalette.ink,
                            side: const BorderSide(color: BistroPalette.line),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Assign', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                    if (hasCheckIn) ...[
                      if (hasEdit || hasAssign) const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showMessage('Guest checked in successfully!'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BistroPalette.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Check In', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                    if (!hasEdit && !hasCheckIn && !hasAssign)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showMessage('Showing reservation details'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: BistroPalette.ink,
                            side: const BorderSide(color: BistroPalette.line),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Details', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitlistItem(String name, String details, String waitTime) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BistroPalette.ink)),
              Text(waitTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: BistroPalette.orange)),
            ],
          ),
          const SizedBox(height: 4),
          Text(details, style: const TextStyle(fontSize: 12, color: BistroPalette.muted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showMessage('Guest paged via SMS'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BistroPalette.orange,
                    side: const BorderSide(color: BistroPalette.orangeSoft, width: 2),
                    backgroundColor: BistroPalette.orangeSoft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Page', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showMessage('Seating guest from waitlist...'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BistroPalette.ink,
                    side: const BorderSide(color: BistroPalette.line),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Seat', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
