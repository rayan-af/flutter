import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  int _selectedFloor = 0; // 0 for Ground, 1 for Rooftop
  final List<String> _floors = ["Ground Floor", "Rooftop"];

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
                selectedColor: theme.colorScheme.onSurface, // Inverts based on theme
                backgroundColor: theme.canvasColor,
                labelStyle: TextStyle(
                  color: isSelected ? theme.colorScheme.surface : theme.colorScheme.onSurface,
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
              border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: InteractiveViewer(
                minScale: 0.3,
                maxScale: 2.5,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(200),
                child: SizedBox(
                  width: 2200,
                  height: 1500,
                  child: Stack(
                    children: [
                      // Floor indicator (watermark style)
                      Center(
                        child: Text(
                          _floors[_selectedFloor],
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.dividerColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      
                      // Render Tables
                      ...tables.map((table) {
                        final isSelected = widget.reservation.selectedTable?.id == table.id;
                        return Positioned(
                          left: table.x.toDouble(),
                          top: table.y.toDouble(),
                          child: _buildTableWidget(context, table, isSelected),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem(theme, theme.colorScheme.surfaceContainerHighest, "Available"),
              _buildLegendItem(theme, theme.colorScheme.secondary, "Selected"),
              _buildLegendItem(theme, theme.colorScheme.onSurface.withValues(alpha: 0.5), "Reserved"),

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
    final isDark = theme.brightness == Brightness.dark;
    final availableColor = theme.colorScheme.surfaceContainerHighest;
    final selectedColor = theme.colorScheme.secondary; 
    final reservedColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    
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
      chairColor = theme.colorScheme.onSurface.withValues(alpha: 0.2);
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
                ? Icon(Icons.close, color: theme.colorScheme.surface.withValues(alpha: 0.5), size: 16)
                : Text(
                    table.label,
                    style: TextStyle(
                      color: isSelected 
                          ? theme.colorScheme.onSecondary 
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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

    if (table.shape == TableShape.circle) {
      final radius = (table.width / 2) + gap + (chairSize / 2);
      for (int i = 0; i < table.seats; i++) {
        final angle = (i * 2 * math.pi) / table.seats;
        chairs.add(
          Transform.translate(
            offset: Offset(
              radius * math.cos(angle),
              radius * math.sin(angle)
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
    } else {
      bool horizontalPlacement = table.width >= table.height;
      
      if (horizontalPlacement) {
         chairs.add(Positioned(top: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate((table.seats / 2).ceil(), (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _chair(color, chairSize, vertical: false))),
         )));
         chairs.add(Positioned(bottom: -chairSize - gap, child: Row(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats / 2).ceil(), (i) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: _chair(color, chairSize, vertical: false))),
         )));
      } else {
         chairs.add(Positioned(left: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate((table.seats / 2).ceil(), (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: _chair(color, chairSize, vertical: true))),
         )));
         chairs.add(Positioned(right: -chairSize - gap, child: Column(
           mainAxisSize: MainAxisSize.min,
           children: List.generate(table.seats - (table.seats / 2).ceil(), (i) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: _chair(color, chairSize, vertical: true))),
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
