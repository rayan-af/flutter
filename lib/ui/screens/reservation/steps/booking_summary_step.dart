import 'package:flutter/material.dart';
import '../../../../core/models/reservation_models.dart';

class BookingSummaryStep extends StatelessWidget {
  final ReservationModel reservation;

  const BookingSummaryStep({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock calculations 
    const subtotal = 206.45;
    const tax = 20.60;
    const total = 227.05;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.receipt_long_rounded, size: 32, color: theme.primaryColor),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildRow("Name", reservation.customerName.isNotEmpty ? reservation.customerName : "Guest", theme),
            const SizedBox(height: 16),
            _buildRow("Phone Number", reservation.phoneNumber.isNotEmpty ? reservation.phoneNumber : "-", theme),
            const SizedBox(height: 16),
            _buildRow("Email", "example@gmail.com", theme),
            const SizedBox(height: 16),
            _buildRow("Date", "20 July 2024", theme),
            const SizedBox(height: 16),
            _buildRow("Time", "14:00", theme),
            const SizedBox(height: 16),
            _buildRow("Party Size", "${reservation.partySize} People", theme),

            _buildDivider(theme),

            _buildAmountRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}", theme),
            const SizedBox(height: 12),
            _buildAmountRow("Tax", "\$${tax.toStringAsFixed(2)}", theme),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Grand Total", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                  Text("\$${total.toStringAsFixed(2)}", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildAmountRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8))),
        Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
