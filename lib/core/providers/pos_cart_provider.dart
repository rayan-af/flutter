import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/dish_model.dart';
part 'pos_cart_provider.g.dart';

@riverpod
class PosCart extends _$PosCart {
  @override
  Map<DishModel, int> build() => {};

  void addItem(DishModel dish) {
    state = {...state, dish: (state[dish] ?? 0) + 1};
  }

  void removeItem(DishModel dish) {
    if (state.containsKey(dish)) {
      if (state[dish]! > 1) {
        state = {...state, dish: state[dish]! - 1};
      } else {
        final newState = Map<DishModel, int>.from(state);
        newState.remove(dish);
        state = newState;
      }
    }
  }

  void clearCart() {
    state = {};
  }
}
