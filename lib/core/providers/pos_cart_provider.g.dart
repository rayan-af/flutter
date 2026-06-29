// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PosCart)
final posCartProvider = PosCartProvider._();

final class PosCartProvider
    extends $NotifierProvider<PosCart, Map<DishModel, int>> {
  PosCartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posCartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posCartHash();

  @$internal
  @override
  PosCart create() => PosCart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DishModel, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<DishModel, int>>(value),
    );
  }
}

String _$posCartHash() => r'c90f8a46f8f2bfcd8b4b13fbecba588d3eb34da9';

abstract class _$PosCart extends $Notifier<Map<DishModel, int>> {
  Map<DishModel, int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<DishModel, int>, Map<DishModel, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<DishModel, int>, Map<DishModel, int>>,
              Map<DishModel, int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
