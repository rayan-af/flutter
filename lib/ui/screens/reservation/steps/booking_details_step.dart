import 'package:flutter/material.dart';
import '../../../../core/models/reservation_models.dart';

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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Full Name",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.customerName,
              decoration: _inputDecoration("Your full name"),
              onChanged: (value) => widget.reservation.customerName = value,
            ),
            
            const SizedBox(height: 20),
            
            Text(
              "Phone Number",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.phoneNumber,
              decoration: _inputDecoration("Enter phone number"),
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
                      Text("Date", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Mock Date Picker
                      _dropdown(theme, "Select Date", ["Today, 20 July", "Tomorrow, 21 July"]),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      // Mock Time Picker
                      _dropdown(theme, "Select Time", ["19:00 PM", "20:00 PM", "21:00 PM"]),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Party Size",
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8),
            _dropdown(theme, "2 People", ["2 People", "4 People", "6 People", "8+ People"]),

            const SizedBox(height: 20),

            Text(
              "Notes",
               style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
             const SizedBox(height: 8),
            TextFormField(
              initialValue: widget.reservation.notes,
              decoration: _inputDecoration("Special requests..."),
              maxLines: 3,
              onChanged: (value) => widget.reservation.notes = value,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _dropdown(ThemeData theme, String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first, // Mock logic
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {}, // Mock logic
        ),
      ),
    );
  }
}
