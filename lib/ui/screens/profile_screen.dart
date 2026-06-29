import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/language_provider.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _imageController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _nameController = TextEditingController(text: user?.name ?? '');
    _imageController = TextEditingController(text: user?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final success = await ref.read(authProvider.notifier).updateProfile(
      _nameController.text.trim(),
      _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdated)),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdateFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    final themeMode = ref.watch(currentThemeNameProvider);
    final currentLocale = ref.watch(languageProvider);
    final user = ref.watch(authProvider);

    final isGuest = user?.role == UserRole.customer;

    return Scaffold(
      appBar: AppBar(
        title: Text(isGuest ? l10n.settingsTitle : l10n.profileTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isGuest) ...[
                // Avatar Preview
                Center(
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.primary, width: 2),
                      image: _imageController.text.isNotEmpty 
                        ? DecorationImage(
                            image: NetworkImage(_imageController.text),
                            fit: BoxFit.cover,
                            onError: (_, __) {}
                          ) 
                        : null,
                    ),
                    child: _imageController.text.isEmpty
                        ? Icon(Icons.person, size: 60, color: theme.colorScheme.primary)
                        : null,
                  ),
                ),
                const SizedBox(height: 32),
                
                Text(l10n.nameLabel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: l10n.nameHint),
                  validator: (val) => (val == null || val.trim().isEmpty) ? l10n.nameError : null,
                ),

                const SizedBox(height: 24),

                Text(l10n.profileImageLabel, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(hintText: l10n.profileImageHint),
                  onChanged: (_) => setState(() {}), // update preview
                ),

                const SizedBox(height: 32),
              ],

              // Theme Dropdown
              Text(l10n.themeSettings, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: themeMode,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: [
                  DropdownMenuItem(
                    value: 'light',
                    child: Row(
                      children: [
                        const Icon(Icons.wb_sunny_rounded, size: 18),
                        const SizedBox(width: 10),
                        Text(l10n.lightTheme),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'dark',
                    child: Row(
                      children: [
                        const Icon(Icons.nightlight_round, size: 18),
                        const SizedBox(width: 10),
                        Text(l10n.darkTheme),
                      ],
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 'black',
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 18, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Black (AMOLED)'),
                      ],
                    ),
                  ),
                ],
                onChanged: (String? val) {
                  if (val != null) {
                    ref.read(themeProvider.notifier).setThemeMode(val);
                  }
                },
              ),


              const SizedBox(height: 24),

              // Language Dropdown
              Text(l10n.languageSettings, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: currentLocale.value?.languageCode ?? 'en',
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'fr', child: Text('Français')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  DropdownMenuItem(value: 'es', child: Text('Español')),
                  DropdownMenuItem(value: 'ja', child: Text('日本語')),
                ],
                onChanged: (String? val) {
                  if (val != null) {
                    ref.read(languageProvider.notifier).setLanguage(val);
                  }
                },
              ),

              if (!isGuest) ...[
                const SizedBox(height: 48),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSave,
                    child: _isLoading 
                      ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                      : Text(
                          l10n.saveChanges, 
                          style: TextStyle(
                             fontSize: 16, 
                             fontWeight: FontWeight.bold,
                             color: theme.colorScheme.onPrimary,
                          )
                        ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
