// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InventoryNotifier)
final inventoryProvider = InventoryNotifierProvider._();

final class InventoryNotifierProvider
    extends $StreamNotifierProvider<InventoryNotifier, List<InventoryModel>> {
  InventoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryNotifierHash();

  @$internal
  @override
  InventoryNotifier create() => InventoryNotifier();
}

String _$inventoryNotifierHash() => r'03c445905eaa5e6317a39e6f06fd5f4bf847dbdb';

abstract class _$InventoryNotifier
    extends $StreamNotifier<List<InventoryModel>> {
  Stream<List<InventoryModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<InventoryModel>>, List<InventoryModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InventoryModel>>,
                List<InventoryModel>
              >,
              AsyncValue<List<InventoryModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
