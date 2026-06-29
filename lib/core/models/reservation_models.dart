enum TableStatus { available, selected, reserved }
enum TableShape { circle, rectangle, square }

class TableModel {
  final int id;
  final String label;
  final double x;
  final double y;
  final double width;
  final double height;
  final TableShape shape;
  final int seats;
  final int floor; // 0 for Ground, 1 for 1st Floor, etc.
  TableStatus status;

  TableModel({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.shape,
    required this.seats,
    required this.floor,
    this.status = TableStatus.available,
  });

  TableModel copyWith({
    int? id,
    String? label,
    double? x,
    double? y,
    double? width,
    double? height,
    TableShape? shape,
    int? seats,
    int? floor,
    TableStatus? status,
  }) {
    return TableModel(
      id: id ?? this.id,
      label: label ?? this.label,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      shape: shape ?? this.shape,
      seats: seats ?? this.seats,
      floor: floor ?? this.floor,
      status: status ?? this.status,
    );
  }

  // Mock Data
  static List<TableModel> get mockTables => [
    // Ground Floor (0)
    // Row 1 - Top
    TableModel(id: 1, label: "T1", x: 100, y: 100, width: 140, height: 140, shape: TableShape.square, seats: 4, floor: 0),
    TableModel(id: 2, label: "T2", x: 450, y: 100, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 0, status: TableStatus.reserved),
    TableModel(id: 3, label: "T3", x: 800, y: 100, width: 180, height: 140, shape: TableShape.rectangle, seats: 6, floor: 0),
    TableModel(id: 4, label: "T4", x: 1150, y: 100, width: 140, height: 140, shape: TableShape.square, seats: 4, floor: 0),
    TableModel(id: 15, label: "T15", x: 1500, y: 100, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 0),
    TableModel(id: 16, label: "T16", x: 1850, y: 100, width: 180, height: 140, shape: TableShape.rectangle, seats: 6, floor: 0),

    // Row 2 - Middle
    TableModel(id: 5, label: "T5", x: 100, y: 400, width: 200, height: 140, shape: TableShape.rectangle, seats: 6, floor: 0),
    TableModel(id: 6, label: "T6", x: 450, y: 400, width: 160, height: 160, shape: TableShape.circle, seats: 6, floor: 0, status: TableStatus.selected),
    TableModel(id: 7, label: "T7", x: 800, y: 400, width: 160, height: 160, shape: TableShape.circle, seats: 6, floor: 0),
    TableModel(id: 8, label: "T8", x: 1150, y: 400, width: 200, height: 140, shape: TableShape.rectangle, seats: 6, floor: 0, status: TableStatus.reserved),
    TableModel(id: 17, label: "T17", x: 1500, y: 400, width: 160, height: 160, shape: TableShape.circle, seats: 6, floor: 0),
    TableModel(id: 18, label: "T18", x: 1850, y: 400, width: 160, height: 160, shape: TableShape.circle, seats: 6, floor: 0),

    // Row 3 - Bottom
    TableModel(id: 9, label: "T9", x: 100, y: 700, width: 140, height: 140, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 10, label: "T10", x: 450, y: 700, width: 140, height: 140, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 11, label: "T11", x: 800, y: 700, width: 180, height: 140, shape: TableShape.rectangle, seats: 4, floor: 0),
    TableModel(id: 12, label: "T12", x: 1150, y: 700, width: 180, height: 140, shape: TableShape.rectangle, seats: 4, floor: 0, status: TableStatus.reserved),
    TableModel(id: 19, label: "T19", x: 1500, y: 700, width: 140, height: 140, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 20, label: "T20", x: 1850, y: 700, width: 180, height: 140, shape: TableShape.rectangle, seats: 4, floor: 0),

    // Row 4 - Large Groups
    TableModel(id: 13, label: "T13", x: 300, y: 1050, width: 200, height: 200, shape: TableShape.circle, seats: 8, floor: 0),
    TableModel(id: 14, label: "T14", x: 1000, y: 1050, width: 200, height: 200, shape: TableShape.circle, seats: 8, floor: 0),
    TableModel(id: 25, label: "T21", x: 1700, y: 1050, width: 200, height: 200, shape: TableShape.circle, seats: 8, floor: 0),

    // Rooftop (1)
    // The Bar (Top section)
    TableModel(id: 21, label: "Bar 1", x: 300, y: 150, width: 200, height: 80, shape: TableShape.rectangle, seats: 3, floor: 1, status: TableStatus.reserved),
    TableModel(id: 22, label: "Bar 2", x: 600, y: 150, width: 200, height: 80, shape: TableShape.rectangle, seats: 3, floor: 1),
    TableModel(id: 23, label: "Bar 3", x: 900, y: 150, width: 200, height: 80, shape: TableShape.rectangle, seats: 3, floor: 1),
    TableModel(id: 24, label: "Bar 4", x: 1200, y: 150, width: 200, height: 80, shape: TableShape.rectangle, seats: 3, floor: 1),
    
    // Dining 4-Tops (Middle section)
    TableModel(id: 26, label: "D1", x: 300, y: 400, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 27, label: "D2", x: 700, y: 400, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1, status: TableStatus.reserved),
    TableModel(id: 28, label: "D3", x: 1100, y: 400, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 29, label: "D4", x: 500, y: 650, width: 140, height: 140, shape: TableShape.square, seats: 4, floor: 1),
    TableModel(id: 30, label: "D5", x: 900, y: 650, width: 140, height: 140, shape: TableShape.square, seats: 4, floor: 1),
    
    // VIP Section (Right side)
    TableModel(id: 31, label: "VIP 1", x: 1550, y: 350, width: 220, height: 180, shape: TableShape.rectangle, seats: 6, floor: 1, status: TableStatus.selected),
    TableModel(id: 32, label: "VIP 2", x: 1550, y: 650, width: 220, height: 180, shape: TableShape.rectangle, seats: 6, floor: 1),
  ];
}

class ReservationModel {
  TableModel? selectedTable;
  String customerName;
  String phoneNumber;
  String email;
  DateTime date;
  TimeOfDay time; // Using simple TimeOfDay wrapper or string for simplicity in demo
  int partySize;
  String notes;

  ReservationModel({
    this.selectedTable,
    this.customerName = '',
    this.phoneNumber = '',
    this.email = '',
    DateTime? date,
    this.time = const TimeOfDay(hour: 19, minute: 0),
    this.partySize = 2,
    this.notes = '',
  }) : date = date ?? DateTime.now();

  double get totalAmount => 20.0; // Mock booking fee
  double get tax => 2.5;
  double get grandTotal => 22.5;
}

class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay({required this.hour, required this.minute});
  
  String format() {
    final h = hour > 12 ? hour - 12 : hour;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final m = minute.toString().padLeft(2, '0');
    return "$h:$m $ampm";
  }
}
