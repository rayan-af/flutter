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

  // Mock Data
  static List<TableModel> get mockTables => [
    // Ground Floor (0)
    // Row 1 - Top
    TableModel(id: 1, label: "T1", x: 60, y: 60, width: 120, height: 120, shape: TableShape.square, seats: 4, floor: 0),
    TableModel(id: 2, label: "T2", x: 300, y: 60, width: 120, height: 120, shape: TableShape.circle, seats: 4, floor: 0, status: TableStatus.reserved),
    TableModel(id: 3, label: "T3", x: 540, y: 60, width: 160, height: 120, shape: TableShape.rectangle, seats: 6, floor: 0),
    TableModel(id: 4, label: "T4", x: 820, y: 60, width: 120, height: 120, shape: TableShape.square, seats: 4, floor: 0),
    TableModel(id: 15, label: "T15", x: 1060, y: 60, width: 120, height: 120, shape: TableShape.circle, seats: 4, floor: 0),
    TableModel(id: 16, label: "T16", x: 1300, y: 60, width: 160, height: 120, shape: TableShape.rectangle, seats: 6, floor: 0),

    // Row 2 - Middle
    TableModel(id: 5, label: "T5", x: 60, y: 280, width: 180, height: 120, shape: TableShape.rectangle, seats: 6, floor: 0),
    TableModel(id: 6, label: "T6", x: 300, y: 280, width: 140, height: 140, shape: TableShape.circle, seats: 6, floor: 0, status: TableStatus.selected),
    TableModel(id: 7, label: "T7", x: 540, y: 280, width: 140, height: 140, shape: TableShape.circle, seats: 6, floor: 0),
    TableModel(id: 8, label: "T8", x: 820, y: 280, width: 180, height: 120, shape: TableShape.rectangle, seats: 6, floor: 0, status: TableStatus.reserved),
    TableModel(id: 17, label: "T17", x: 1060, y: 280, width: 140, height: 140, shape: TableShape.circle, seats: 6, floor: 0),
    TableModel(id: 18, label: "T18", x: 1300, y: 280, width: 140, height: 140, shape: TableShape.circle, seats: 6, floor: 0),

    // Row 3 - Bottom
    TableModel(id: 9, label: "T9", x: 60, y: 500, width: 120, height: 120, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 10, label: "T10", x: 300, y: 500, width: 120, height: 120, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 11, label: "T11", x: 540, y: 500, width: 160, height: 120, shape: TableShape.rectangle, seats: 4, floor: 0),
    TableModel(id: 12, label: "T12", x: 820, y: 500, width: 160, height: 120, shape: TableShape.rectangle, seats: 4, floor: 0, status: TableStatus.reserved),
    TableModel(id: 19, label: "T19", x: 1060, y: 500, width: 120, height: 120, shape: TableShape.square, seats: 2, floor: 0),
    TableModel(id: 20, label: "T20", x: 1300, y: 500, width: 160, height: 120, shape: TableShape.rectangle, seats: 4, floor: 0),

    // Row 4 - Extra spacing / Bottom Area
    TableModel(id: 13, label: "T13", x: 200, y: 720, width: 150, height: 150, shape: TableShape.circle, seats: 8, floor: 0),
    TableModel(id: 14, label: "T14", x: 700, y: 720, width: 150, height: 150, shape: TableShape.circle, seats: 8, floor: 0),
    TableModel(id: 25, label: "T21", x: 1100, y: 720, width: 150, height: 150, shape: TableShape.circle, seats: 8, floor: 0),


    // 1st Floor (1)
    TableModel(id: 21, label: "R1", x: 150, y: 150, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 22, label: "R2", x: 500, y: 150, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 23, label: "R3", x: 150, y: 450, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1, status: TableStatus.reserved),
    TableModel(id: 24, label: "R4", x: 500, y: 450, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 26, label: "R5", x: 850, y: 150, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
    TableModel(id: 27, label: "R6", x: 850, y: 450, width: 140, height: 140, shape: TableShape.circle, seats: 4, floor: 1),
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
