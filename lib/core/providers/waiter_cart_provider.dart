import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dish_model.dart';

final waiterCartProvider = NotifierProvider<WaiterCartNotifier, List<DishModel>>(WaiterCartNotifier.new);

class WaiterCartNotifier extends Notifier<List<DishModel>> {
  @override
  List<DishModel> build() => [];

  void addItem(DishModel dish) {
    state = [...state, dish];
  }

  void removeItem(DishModel dish) {
    final index = state.indexOf(dish);
    if (index != -1) {
      final newState = List<DishModel>.from(state);
      newState.removeAt(index);
      state = newState;
    }
  }

  void clearCart() {
    state = [];
  }
}
