import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stock_provider.g.dart';

@riverpod
class StockNotifier extends _$StockNotifier {
  @override
  Map<String, int> build() => {
    "Coffee Beans": 15, // kg
    "Oat Milk": 8,      // Liters
    "Vanilla Syrup": 3, // Bottles
  };

  void updateStock(String item, int amount) {
    state = {...state, item: amount};
  }
}
