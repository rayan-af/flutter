import 'package:flutter/material.dart';

class TableSelectionSheet extends StatelessWidget {
  const TableSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Mock Data for Tables
    final tables = List.generate(12, (index) {
      // Randomly assign status
      final isReserved = index % 3 == 0; 
      return {'id': index + 1, 'isReserved': isReserved};
    });

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Select a Table",
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegend(theme, false, "Available"),
              const SizedBox(width: 16),
              _buildLegend(theme, true, "Reserved"),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                final id = table['id'] as int;
                final isReserved = table['isReserved'] as bool;
                
                return _buildTableItem(context, theme, id, isReserved);
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Confirm Booking"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme, bool isReserved, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReserved ? theme.primaryColor : Colors.transparent,
            border: Border.all(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildTableItem(BuildContext context, ThemeData theme, int id, bool isReserved) {
    return InkWell(
      onTap: isReserved ? null : () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isReserved 
              ? theme.primaryColor 
              : theme.scaffoldBackgroundColor,
          border: Border.all(
            color: theme.primaryColor,
            width: 2,
          ),
          boxShadow: isReserved ? [] : [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Center(
          child: Text(
            "$id",
            style: theme.textTheme.titleMedium?.copyWith(
              color: isReserved ? theme.colorScheme.onPrimary : theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
