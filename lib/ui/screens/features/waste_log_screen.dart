import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/providers/inventory_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../../l10n/app_localizations.dart';

class WasteLogScreen extends ConsumerStatefulWidget {
  const WasteLogScreen({super.key});

  @override
  ConsumerState<WasteLogScreen> createState() => _WasteLogScreenState();
}

class _WasteLogScreenState extends ConsumerState<WasteLogScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedItem;
  String? _selectedReason;
  final TextEditingController _quantityController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryProvider);
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final itemsList = inventoryState.value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wasteLogTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Log Form
            Expanded(
              flex: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.logSpoilage, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 24),
                        // Dropdown for Inventory Items
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Item'),
                          value: _selectedItem,
                          items: itemsList.map((item) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                             setState(() => _selectedItem = value);
                          },
                          validator: (value) => value == null ? l10n.selectItem : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(labelText: l10n.quantityWasted),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) return l10n.enterQuantity;
                            if (double.tryParse(value) == null) return l10n.invalidNumber;
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                         DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: l10n.reason),
                          value: _selectedReason,
                          items: [
                            DropdownMenuItem(value: 'Expired', child: Text(l10n.expired)),
                            DropdownMenuItem(value: 'Spilled', child: Text(l10n.spilled)),
                            DropdownMenuItem(value: 'Bad Quality', child: Text(l10n.badQuality)),
                             DropdownMenuItem(value: 'Mistake', child: Text(l10n.mistake)),
                          ],
                          onChanged: (value) => setState(() => _selectedReason = value),
                          validator: (value) => value == null ? l10n.selectReason : null,
                        ),
                         const SizedBox(height: 24),
                         SizedBox(
                           width: double.infinity,
                           child: ElevatedButton(
                             onPressed: _isLoading ? null : () => _submitLog(user?.id ?? 'manager'),
                             style: ElevatedButton.styleFrom(
                               backgroundColor: theme.colorScheme.error,
                               foregroundColor: Colors.white,
                             ),
                              child: _isLoading 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Text(l10n.logWaste),
                            ),
                         )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Recent Logs List
            Expanded(
              flex: 2,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.recentWasteLogs, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestoreService.getWasteLogsStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                             return const Center(child: CircularProgressIndicator());
                          }
                          
                          final logs = snapshot.data?.docs ?? [];
                          
                          if (logs.isEmpty) {
                            return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(l10n.noWasteLogs)));
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logs.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final data = logs[index].data() as Map<String, dynamic>;
                              final timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                              
                              final itemId = data['itemId'] as String;
                              
                              String itemName = 'Unknown Item ($itemId)';
                              String itemUnit = '';
                              try {
                                final item = itemsList.firstWhere((i) => i.id == itemId);
                                itemName = item.name;
                                itemUnit = item.unit;
                              } catch (_) {}

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Text(
                                  "${timestamp.month}/${timestamp.day} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                                title: Text(
                                  itemName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${data['quantity']} $itemUnit • ${data['reason']}',
                                  style: TextStyle(color: theme.colorScheme.error),
                                ),
                                trailing: Text(
                                  'User: ${data['userId']}', 
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              );
                            },
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Future<void> _submitLog(String userId) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final quantity = double.parse(_quantityController.text);
      await _firestoreService.logWaste(_selectedItem!, quantity, _selectedReason!, userId);

      _quantityController.clear();
      setState(() {
         _isLoading = false; 
      });

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.wasteLoggedSuccess), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
