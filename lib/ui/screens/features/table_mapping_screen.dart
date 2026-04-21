import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../../core/models/reservation_models.dart';

class TableMappingScreen extends StatefulWidget {
  const TableMappingScreen({super.key});

  @override
  State<TableMappingScreen> createState() => _TableMappingScreenState();
}

class _TableMappingScreenState extends State<TableMappingScreen> {
  int _selectedFloor = 0; 
  final List<String> _floors = ["Ground Floor", "1st Floor", "2nd Floor", "Rooftop"];
  
  late List<TableModel> _mapTables;

  @override
  void initState() {
    super.initState();
    // Initialize mock data uniquely for this session
    _mapTables = TableModel.mockTables.map((t) {
       TableStatus status = t.status;
       // Add visual variety based on mock IDs
       if (t.id == 2 || t.id == 5 || t.id == 8 || t.id == 21) status = TableStatus.reserved;
       if (t.id == 3 || t.id == 9 || t.id == 15 || t.id == 22) status = TableStatus.selected; // Using selected as 'Occupied' for visual difference
       return t.copyWith(status: status);
    }).toList();
  }

  void _onTableTapped(TableModel table) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) {
           return SafeArea(
             child: Padding(
               padding: const EdgeInsets.all(24.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   Center(
                     child: Container(
                       width: 40, height: 4, 
                       margin: const EdgeInsets.only(bottom: 24),
                       decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                     )
                   ),
                   Text("Table ${table.label}", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       Icon(Icons.people_outline, size: 20, color: Theme.of(context).colorScheme.primary),
                       const SizedBox(width: 8),
                       Text("${table.seats} Seats"),
                       const SizedBox(width: 16),
                       Icon(Icons.info_outline, size: 20, color: Theme.of(context).colorScheme.primary),
                       const SizedBox(width: 8),
                       Text(_getStatusString(table.status), style: const TextStyle(fontWeight: FontWeight.w600)),
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
                       child: const Text("Seat Walk-In Customer"),
                     ),
                     const SizedBox(height: 12),
                     OutlinedButton(
                       onPressed: () {
                           _updateTable(table.id, TableStatus.reserved);
                           Navigator.pop(context);
                       },
                       child: const Text("Mark as Reserved"),
                     ),
                   ] else ...[
                     OutlinedButton(
                       onPressed: () {
                           _updateTable(table.id, TableStatus.available);
                           Navigator.pop(context);
                       },
                       child: const Text("Clear Table (Available)"),
                     ),
                   ],
                   const SizedBox(height: 12),
                 ],
               ),
             )
           );
        }
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

  String _getStatusString(TableStatus status) {
    if (status == TableStatus.available) return "Available";
    if (status == TableStatus.selected) return "Occupied";
    if (status == TableStatus.reserved) return "Reserved";
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tables = _mapTables.where((t) => t.floor == _selectedFloor).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Mapping"),
        centerTitle: false,
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: Column(
        children: [
          // Floor Selection Tabs
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              scrollDirection: Axis.horizontal,
              itemCount: _floors.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = index == _selectedFloor;
                return ChoiceChip(
                  label: Text(_floors[index]),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _selectedFloor = index);
                  },
                  selectedColor: theme.colorScheme.primary, 
                  backgroundColor: theme.canvasColor,
                  labelStyle: TextStyle(
                    color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.2))),
                  showCheckmark: false,
                );
              },
            ),
          ),

          // Map Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? theme.cardColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: Stack(
                children: [
                  // Floor indicator
                  Center(
                    child: Text(
                      _floors[_selectedFloor],
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.dividerColor.withValues(alpha: 0.05),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Render Tables
                  ...tables.map((table) {
                    return Positioned(
                      left: table.x,
                      top: table.y,
                      child: _buildTableWidget(context, table),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildLegendItem(theme, Colors.grey[400]!, "Available"),
                  _buildLegendItem(theme, theme.colorScheme.primary, "Occupied"),
                  _buildLegendItem(theme, theme.colorScheme.error, "Reserved"), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableWidget(BuildContext context, TableModel table) {
    final theme = Theme.of(context);
    
    // Status Colors mapping
    Color tableColor;
    Color chairColor;
    
    if (table.status == TableStatus.reserved) {
      tableColor = theme.colorScheme.error; // Red for reserved to stand out
      chairColor = theme.colorScheme.error.withOpacity(0.6);
    } else if (table.status == TableStatus.selected) {
      // Treating 'selected' as 'Occupied' for this view
      tableColor = theme.colorScheme.primary;
      chairColor = theme.colorScheme.primary.withOpacity(0.8);
    } else {
      tableColor = Colors.grey[400]!;
      chairColor = Colors.grey[300]!;
    }

    return GestureDetector(
      onTap: () => _onTableTapped(table),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Chairs
          ..._buildChairs(table, chairColor),
          
          // Table Top
          Container(
            width: table.width,
            height: table.height,
            decoration: BoxDecoration(
              color: tableColor,
              shape: table.shape == TableShape.circle ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: table.shape == TableShape.rectangle ? BorderRadius.circular(12) : null,
              border: Border.all(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: table.status != TableStatus.available ? [
                BoxShadow(
                  color: tableColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Center(
              child: Text(
                  table.label,
                  style: TextStyle(
                    color: table.status != TableStatus.available ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChairs(TableModel table, Color color) {
    List<Widget> chairs = [];
    final double chairSize = 14;
    final double gap = 6; 
    
    if (table.shape == TableShape.circle) {
       if (table.seats >= 1) chairs.add(Positioned(top: -chairSize - gap, child: _chair(color, chairSize, vertical: false)));
       if (table.seats >= 2) chairs.add(Positioned(bottom: -chairSize - gap, child: _chair(color, chairSize, vertical: false)));
       if (table.seats >= 3) chairs.add(Positioned(left: -chairSize - gap, child: _chair(color, chairSize, vertical: true)));
       if (table.seats >= 4) chairs.add(Positioned(right: -chairSize - gap, child: _chair(color, chairSize, vertical: true)));
    } else {
      bool horizontalPlacement = table.width >= table.height;
      if (horizontalPlacement) {
         chairs.add(Positioned(top: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats ~/ 2, (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: _chair(color, chairSize, vertical: false))),
         )));
         chairs.add(Positioned(bottom: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats ~/ 2), (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: _chair(color, chairSize, vertical: false))),
         )));
      } else {
         chairs.add(Positioned(left: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats ~/ 2, (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: _chair(color, chairSize, vertical: true))),
         )));
         chairs.add(Positioned(right: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats ~/ 2), (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: _chair(color, chairSize, vertical: true))),
         )));
      }
    }
    return chairs;
  }

  Widget _chair(Color color, double size, {required bool vertical}) {
    return Container(
      width: vertical ? size / 2 : size,
      height: vertical ? size : size / 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLegendItem(ThemeData theme, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14, height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
