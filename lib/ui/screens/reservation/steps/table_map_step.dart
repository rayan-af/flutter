import 'package:flutter/material.dart';
import '../../../../core/models/reservation_models.dart';

class TableMapStep extends StatefulWidget {
  final ReservationModel reservation;
  final Function(TableModel) onTableSelected;

  const TableMapStep({
    super.key,
    required this.reservation,
    required this.onTableSelected,
  });

  @override
  State<TableMapStep> createState() => _TableMapStepState();
}

class _TableMapStepState extends State<TableMapStep> {
  int _selectedFloor = 0; // 0 for Ground, 1 for 1st Floor
  final List<String> _floors = ["Ground Floor", "1st Floor", "2nd Floor", "Rooftop"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Filter tables for current floor
    final tables = TableModel.mockTables.where((t) => t.floor == _selectedFloor).toList();

    return Column(
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
                selectedColor: Colors.black, // Dark for selected like reference
                backgroundColor: theme.canvasColor,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
            ),
            child: Stack(
              children: [
                // Floor indicator (watermark style)
                Center(
                  child: Text(
                    _floors[_selectedFloor],
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                
                // Render Tables
                ...tables.map((table) {
                  final isSelected = widget.reservation.selectedTable?.id == table.id;
                  return Positioned(
                    left: table.x,
                    top: table.y,
                    child: _buildTableWidget(context, table, isSelected),
                  );
                }),
              ],
            ),
          ),
        ),
        
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(theme, Colors.grey[300]!, "Available"),
              _buildLegendItem(theme, theme.colorScheme.secondary, "Selected"),
              _buildLegendItem(theme, Colors.grey[800]!, "Reserved"), // Dark grey for reserved
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableWidget(BuildContext context, TableModel table, bool isSelected) {
    final theme = Theme.of(context);
    if (table.status == TableStatus.reserved) isSelected = false;

    // Colors
    final availableColor = Colors.grey[200]!;
    final selectedColor = theme.colorScheme.secondary; // Use Dark Gold (secondary)
    final reservedColor = Colors.grey[300]!;
    
    Color tableColor;
    Color chairColor;
    
    if (table.status == TableStatus.reserved) {
      tableColor = reservedColor;
      chairColor = reservedColor.withValues(alpha: 0.5);
    } else if (isSelected) {
      tableColor = selectedColor;
      chairColor = selectedColor;
    } else {
      tableColor = availableColor;
      chairColor = Colors.grey[300]!;
    }

    return GestureDetector(
      onTap: table.status == TableStatus.available 
          ? () {
              widget.onTableSelected(table);
              setState(() {});
            } 
          : null,
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
              borderRadius: table.shape == TableShape.rectangle ? BorderRadius.circular(8) : null,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: selectedColor.withValues(alpha: 0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Center(
              child: table.status == TableStatus.reserved 
                ? Icon(Icons.close, color: Colors.white.withValues(alpha: 0.5), size: 16)
                : Text(
                    table.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
            ),
          ),
          
          // Selected Checkmark
          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 10, color: selectedColor),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildChairs(TableModel table, Color color) {
    List<Widget> chairs = [];
    final double chairSize = 14;
    final double gap = 4; // Gap between table and chair

    // Simplified chair placement logic based on shape and seats
    // This is a visual approximation
    
    if (table.shape == TableShape.circle) {
      // Radial distribution
      final radius = (table.width / 2) + gap + (chairSize / 2);
      for (int i = 0; i < table.seats; i++) {
        final angle = (i * 2 * 3.14159) / table.seats;
        chairs.add(
          Transform.translate(
            offset: Offset(
              radius * -1 * (i % 2 == 0 ? 1 : 1) * 0 + radius * 1, // Buggy math fix below - simpler generic trig
              0
            ),
            child: Transform.rotate(
              angle: angle,
               child: Container(
                 width: chairSize,
                 height: chairSize,
                 decoration: BoxDecoration(
                   color: color,
                   shape: BoxShape.circle,
                 ),
               ),
            ),
          )
        );
      }
      // Since manual trig in standard widgets is tricky without proper layout, 
      // let's use a simpler approach for the demo: 4 fixed positions for circle
      chairs.clear();
       if (table.seats >= 1) chairs.add(Positioned(top: -chairSize - gap, child: _chair(color, chairSize, vertical: false)));
       if (table.seats >= 2) chairs.add(Positioned(bottom: -chairSize - gap, child: _chair(color, chairSize, vertical: false)));
       if (table.seats >= 3) chairs.add(Positioned(left: -chairSize - gap, child: _chair(color, chairSize, vertical: true)));
       if (table.seats >= 4) chairs.add(Positioned(right: -chairSize - gap, child: _chair(color, chairSize, vertical: true)));
       
    } else {
      // Rectangle/Square
      // Top & Bottom
      // Heuristic: If width >= height, place top/bottom. Else left/right.
      bool horizontalPlacement = table.width >= table.height;
      
      if (horizontalPlacement) {
         // Top chairs
         chairs.add(Positioned(top: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats ~/ 2, (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _chair(color, chairSize, vertical: false))),
         )));
         // Bottom chairs
         chairs.add(Positioned(bottom: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats ~/ 2), (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _chair(color, chairSize, vertical: false))),
         )));
      } else {
        // Left/Right
         chairs.add(Positioned(left: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats ~/ 2, (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: _chair(color, chairSize, vertical: true))),
         )));
         chairs.add(Positioned(right: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats ~/ 2), (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: _chair(color, chairSize, vertical: true))),
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
          width: 16, height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
