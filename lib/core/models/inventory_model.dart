class InventoryModel {
  final String id;
  final String name;
  final double quantity;
  final double threshold;
  final String unit;
  final double cost; // Cost per unit

  bool get isLowStock => quantity <= threshold;

  InventoryModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.threshold,
    required this.unit,
    this.cost = 0.0,
  });

  InventoryModel copyWith({
    String? id,
    String? name,
    double? quantity,
    double? threshold,
    String? unit,
    double? cost,
  }) {
    return InventoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      threshold: threshold ?? this.threshold,
      unit: unit ?? this.unit,
      cost: cost ?? this.cost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'threshold': threshold,
      'unit': unit,
      'cost': cost,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return InventoryModel(
      id: documentId,
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      threshold: (map['threshold'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      cost: (map['cost'] ?? 0).toDouble(),
    );
  }
}
