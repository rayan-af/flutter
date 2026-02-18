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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text(reservation.customerName.isNotEmpty ? reservation.customerName : "Guest", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Phone Number", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text(reservation.phoneNumber.isNotEmpty ? reservation.phoneNumber : "-", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
           const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Email", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text("example@gmail.com", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)), // Mock
            ],
          ),
          const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text("20 July 2024", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
           const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Time", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text("14:00", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Number of Person", style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              Text("${reservation.partySize} People", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: theme.textTheme.bodyLarge),
              Text("\$${subtotal.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tax", style: theme.textTheme.bodyLarge),
              Text("\$${tax.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Grand Total", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text("\$${total.toStringAsFixed(2)}", style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}
