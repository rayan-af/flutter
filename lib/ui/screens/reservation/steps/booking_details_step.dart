import 'package:flutter/material.dart';
import '../../../../core/models/reservation_models.dart';
import '../../../../l10n/app_localizations.dart';

class BookingDetailsStep extends StatefulWidget {
  final ReservationModel reservation;

  const BookingDetailsStep({super.key, required this.reservation});

  @override
  State<BookingDetailsStep> createState() => _BookingDetailsStepState();
}

class _BookingDetailsStepState extends State<BookingDetailsStep> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.fullNameLabel,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.customerName,
              decoration: _inputDecoration(theme, l10n.fullNameLabel, icon: Icons.person_outline),
              onChanged: (value) => widget.reservation.customerName = value,
            ),
            
            const SizedBox(height: 20),
            
            Text(
              l10n.phoneNumberLabel,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.phoneNumber,
              decoration: _inputDecoration(theme, l10n.phoneNumberLabel, icon: Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              onChanged: (value) => widget.reservation.phoneNumber = value,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.dateLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Mock Date Picker
                      _dropdown(theme, "Today, 20 July", ["Today, 20 July", "Tomorrow, 21 July"], Icons.calendar_today_outlined),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.timeLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Mock Time Picker
                      _dropdown(theme, "19:00 PM", ["19:00 PM", "20:00 PM", "21:00 PM"], Icons.access_time_rounded),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              l10n.partySizeLabel,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8),
            _dropdown(theme, "2 People", ["2 People", "4 People", "6 People", "8+ People"], Icons.people_outline),

            const SizedBox(height: 20),

            Text(
              l10n.notesLabel,
               style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.notes,
              decoration: _inputDecoration(theme, l10n.specialRequests),
              maxLines: 3,
              onChanged: (value) => widget.reservation.notes = value,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.4)),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      prefixIcon: icon != null ? Icon(icon, color: theme.colorScheme.primary) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _dropdown(ThemeData theme, String value, List<String> items, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first, // Mock logic
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      value, 
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (_) {}, // Mock logic
        ),
      ),
    );
  }
}
