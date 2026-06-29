import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../core/models/dish_model.dart';
import '../../../core/services/firestore_service.dart';
import '../../widgets/role_shell.dart';
import '../../widgets/dish_image.dart';
import '../../../l10n/app_localizations.dart';

class DishEditorScreen extends StatefulWidget {
  final DishModel? dish;

  const DishEditorScreen({super.key, this.dish});

  @override
  State<DishEditorScreen> createState() => _DishEditorScreenState();
}

class _DishEditorScreenState extends State<DishEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _imageUrlController;

  bool _isSaving = false;
  bool _isUploadingImage = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dish?.name ?? '');
    _categoryController = TextEditingController(text: widget.dish?.category ?? 'Entrees');
    _priceController = TextEditingController(text: widget.dish?.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.dish?.description ?? '');
    _caloriesController = TextEditingController(text: widget.dish?.calories.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.dish?.imageUrl ?? 'https://placehold.co/400x400/1E1E2C/FFF');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _caloriesController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final double price = double.parse(_priceController.text);
      final int calories = int.parse(_caloriesController.text);

      final updates = {
        'name': _nameController.text.trim(),
        'category': _categoryController.text.trim(),
        'price': price,
        'description': _descriptionController.text.trim(),
        'calories': calories,
        'imageUrl': _imageUrlController.text.trim(),
      };

      if (widget.dish == null) {
        updates['ingredients'] = [];
        updates['recipe'] = {};
        updates['orderCount'] = 0;
        updates['rating'] = 0.0;
        updates['reviewCount'] = 0;
        await FirestoreService().addNewDish(updates);
      } else {
        await FirestoreService().updateRecipeItem(widget.dish!.id, updates);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.dish == null ? 'Menu item created successfully!' : 'Menu item updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving changes: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.page,
          customRouteBuilder: (cropper, initCropper, crop, rotate, scale) {
            return MaterialPageRoute(
              builder: (context) {
                double scaleValue = 0.5;
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Scaffold(
                      backgroundColor: const Color(0xFF1C1C1C),
                      appBar: AppBar(
                        backgroundColor: const Color(0xFF1C1C1C),
                        foregroundColor: Colors.white,
                        title: const Text('Crop Image', style: TextStyle(fontSize: 16)),
                        elevation: 0,
                      ),
                      body: SafeArea(
                        child: Column(
                          children: [
                            // Centered Cropper View
                            Expanded(
                              child: Center(
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 600,
                                    maxHeight: 600,
                                  ),
                                  child: ClipRect(child: cropper),
                                ),
                              ),
                            ),
                            // Orange Slider and Rotate Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.rotate_left, color: Color(0xFFF37B3F)),
                                    onPressed: () => rotate(RotationAngle.counterClockwise90),
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: const Color(0xFFF37B3F),
                                        inactiveTrackColor: Colors.white24,
                                        thumbColor: const Color(0xFFF37B3F),
                                        overlayColor: const Color(0xFFF37B3F).withOpacity(0.2),
                                      ),
                                      child: Slider(
                                        value: scaleValue,
                                        onChanged: (val) {
                                          setState(() => scaleValue = val);
                                          scale(val);
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.rotate_right, color: Color(0xFFF37B3F)),
                                    onPressed: () => rotate(RotationAngle.clockwise90),
                                  ),
                                ],
                              ),
                            ),
                            // Custom Cancel and Crop Buttons
                            Container(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
                              color: const Color(0xFF1C1C1C),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final result = await crop();
                                      if (result != null) {
                                        Navigator.of(context).pop(result);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    ),
                                    child: const Text('CROP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final bytes = await croppedFile.readAsBytes();
      
      // Convert to Base64 to bypass Firebase Storage CORS/Auth issues on Web
      final base64String = base64Encode(bytes);
      final downloadUrl = 'data:image/jpeg;base64,$base64String';

      setState(() {
        _imageUrlController.text = downloadUrl;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: BistroPalette.background,
      appBar: AppBar(
        title: Text(
          widget.dish == null ? l10n.addDishLabel : l10n.editDishLabel,
          style: TextStyle(
            color: BistroPalette.ink,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: BistroPalette.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: BistroPalette.ink),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: BistroPalette.line,
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImagePreview(),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: l10n.dishNameLabel,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: l10n.priceLabel,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _caloriesController,
                      label: l10n.kcalLabel,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (int.tryParse(v) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _categoryController,
                label: l10n.categoryLabel,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: l10n.imageUrlLabel,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onChanged: (val) {
                  // Trigger rebuild for image preview
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: l10n.descriptionLabel,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BistroPalette.ink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.saveDishLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Center(
      child: GestureDetector(
        onTap: _isUploadingImage ? null : _pickAndUploadImage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: BistroPalette.line,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BistroPalette.line),
              ),
              clipBehavior: Clip.antiAlias,
              child: DishImage(
                imageUrl: _imageUrlController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, color: BistroPalette.muted, size: 32),
                    SizedBox(height: 8),
                    Text(
                      'Invalid URL',
                      style: TextStyle(color: BistroPalette.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            if (_isUploadingImage)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            else
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: BistroPalette.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(color: BistroPalette.ink),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: BistroPalette.muted),
        filled: true,
        fillColor: BistroPalette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BistroPalette.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BistroPalette.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: BistroPalette.ink, width: 2),
        ),
      ),
    );
  }
}
