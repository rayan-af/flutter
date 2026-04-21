import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/models/inventory_model.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../../core/services/firestore_service.dart';

class InventoryScreen extends StatefulWidget {
  final bool isReadOnly;

  const InventoryScreen({super.key, required this.isReadOnly});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isAdmin = false;
  
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    final isAdmin = await FirestoreService().checkIfAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReadOnly ? 'Inventory Listing' : 'Inventory Management'),
        backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      // drawer: const CustomDrawer(),
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF5F6FA),
      floatingActionButton: (!widget.isReadOnly && _isAdmin)
          ? FloatingActionButton.extended(
              onPressed: () => _showAddItemDialog(context),
              backgroundColor: const Color(0xFF00C853),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('New Item'),
            )
          : null,
      body: StreamBuilder<List<InventoryModel>>(
        stream: FirestoreService().getInventoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final items = snapshot.data ?? [];
          
          return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // In case table is wide
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(isDark ? const Color(0xFF2D2D3F) : Colors.grey[100]),
              columns: const [
                DataColumn(label: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Price (Cost)', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Quick Quantity', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: items.map((item) {
                return DataRow(cells: [
                  DataCell(
                    Row(
                      children: [
                        Icon(
                            item.unit == 'g' || item.unit == 'ml' ? Icons.science : Icons.fastfood,
                            color: Colors.grey,
                            size: 16
                        ),
                        const SizedBox(width: 8),
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    )
                  ),
                  DataCell(
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text(item.unit == 'ml' ? 'Liquid' : 'Solid', style: const TextStyle(fontSize: 12))
                    )
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isLowStock ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.isLowStock ? 'Low Stock' : 'In Stock',
                        style: TextStyle(
                          color: item.isLowStock ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text('\$${item.cost?.toStringAsFixed(2) ?? "0.00"}')
                  ),
                  DataCell(
                     Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Container(
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey[300]!),
                             borderRadius: BorderRadius.circular(4),
                           ),
                           child: Row(
                             children: [
                               Text('  ${item.quantity.toStringAsFixed(0)}  '),
                               Container(color: Colors.grey[300], width: 1, height: 24),
                               if (!widget.isReadOnly)
                                  IconButton(
                                    icon: const Icon(Icons.check, size: 16, color: Colors.blue), // Save/Update icon visual
                                    // Actually screenshot shows text field. Let's keep it simple.
                                    // Or better, a + button for quick restock
                                    onPressed: () => _showRestockDialog(context, item, inventoryProvider),
                                  )
                               else
                                  const SizedBox(width: 32), // Placeholder gap
                             ],
                           ),
                         ),
                       ],
                     ),
                  ),
                  DataCell(
                    (!widget.isReadOnly && _isAdmin) 
                    ? IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red), 
                        onPressed: () async {
                           final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text('Remove ${item.name} from inventory?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                                ],
                              )
                           );
                           if (confirm == true) {
                             await FirestoreService().deleteInventoryItem(item.id);
                           }
                        }
                      ) 
                    : const SizedBox(),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      );
    },
  ),
  bottomNavigationBar: const CustomBottomNavBar(),
);
  }

  void _showRestockDialog(BuildContext context, InventoryModel item, InventoryProvider provider) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${item.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Add Quantity'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final double? amount = double.tryParse(controller.text);
              if (amount != null && amount != 0) {
                provider.restockItem(item.id, amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final qtyController = TextEditingController();
    final costController = TextEditingController();
    String? selectedUnit;
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isFormValid = nameController.text.trim().isNotEmpty &&
                                qtyController.text.trim().isNotEmpty &&
                                double.tryParse(qtyController.text) != null &&
                                costController.text.trim().isNotEmpty &&
                                double.tryParse(costController.text) != null &&
                                selectedUnit != null;
                                
            return AlertDialog(
              title: const Text('Add Inventory Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Item Name'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: qtyController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: costController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Cost / Price'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedUnit,
                      decoration: const InputDecoration(labelText: 'Unit'),
                      items: const [
                        DropdownMenuItem(value: 'kg', child: Text('kg')),
                        DropdownMenuItem(value: 'L', child: Text('L')),
                        DropdownMenuItem(value: 'Units', child: Text('Units')),
                        DropdownMenuItem(value: 'Boxes', child: Text('Boxes')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedUnit = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isFormValid ? () async {
                    final qty = double.parse(qtyController.text.trim());
                    final cost = double.parse(costController.text.trim());
                    await FirestoreService().addInventoryItem(
                      nameController.text.trim(),
                      qty,
                      selectedUnit!,
                      cost,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item added to Marrakech Inventory!'),
                          backgroundColor: Color(0xFF00C853),
                        ),
                      );
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
