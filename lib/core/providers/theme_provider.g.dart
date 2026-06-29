// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 3 possible theme modes:
///   'light'  → fresh / light theme
///   'dark'   → modern dark theme
///   'black'  → AMOLED "boîte noire" theme

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

/// 3 possible theme modes:
///   'light'  → fresh / light theme
///   'dark'   → modern dark theme
///   'black'  → AMOLED "boîte noire" theme
final class ThemeNotifierProvider
    extends $AsyncNotifierProvider<ThemeNotifier, String> {
  /// 3 possible theme modes:
  ///   'light'  → fresh / light theme
  ///   'dark'   → modern dark theme
  ///   'black'  → AMOLED "boîte noire" theme
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();
}

String _$themeNotifierHash() => r'2f1be7e80374218fc65b2e9d1607d172e4d4786a';

/// 3 possible theme modes:
///   'light'  → fresh / light theme
///   'dark'   → modern dark theme
///   'black'  → AMOLED "boîte noire" theme

abstract class _$ThemeNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(currentTheme)
final currentThemeProvider = CurrentThemeProvider._();

final class CurrentThemeProvider
    extends $FunctionalProvider<ThemeData, ThemeData, ThemeData>
    with $Provider<ThemeData> {
  CurrentThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentThemeHash();

  @$internal
  @override
  $ProviderElement<ThemeData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeData create(Ref ref) {
    return currentTheme(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeData>(value),
    );
  }
}

String _$currentThemeHash() => r'4671469c3fcf89fed6313cce52a7df30203204f2';

@ProviderFor(currentThemeName)
final currentThemeNameProvider = CurrentThemeNameProvider._();

final class CurrentThemeNameProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  CurrentThemeNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentThemeNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentThemeNameHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentThemeName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentThemeNameHash() => r'1f83e17e37a31a93185ccd76854aa986dd8f5380';

/// Convenience: is the current mode one of the dark variants?

@ProviderFor(isDarkMode)
final isDarkModeProvider = IsDarkModeProvider._();

/// Convenience: is the current mode one of the dark variants?

final class IsDarkModeProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Convenience: is the current mode one of the dark variants?
  IsDarkModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDarkModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDarkModeHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isDarkMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isDarkModeHash() => r'41fc1dc1b8c8df4506188f4359aef8701498ce07';
