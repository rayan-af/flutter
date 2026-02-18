import 'package:flutter/material.dart';
import '../../../core/models/reservation_models.dart';
import 'steps/table_map_step.dart';
import 'steps/booking_details_step.dart';
import 'steps/booking_summary_step.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _currentStep = 0;
  final ReservationModel _reservation = ReservationModel();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // Confirm Logic
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservation Confirmed!")),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  void _onTableSelected(TableModel table) {
    setState(() {
      _reservation.selectedTable = table;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getStepTitle(),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: theme.dividerColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(theme.primaryColor),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                TableMapStep(
                  reservation: _reservation,
                  onTableSelected: _onTableSelected,
                ),
                BookingDetailsStep(reservation: _reservation),
                BookingSummaryStep(reservation: _reservation),
              ],
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _canProceed() ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_currentStep == 2 ? "Pay and Reserve" : "Continue"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return "Select Table";
      case 1: return "Information Detail";
      case 2: return "Order Summary";
      default: return "";
    }
  }

  bool _canProceed() {
    if (_currentStep == 0) return _reservation.selectedTable != null;
    // For step 1 and 2, simple validation (can be enhanced)
    return true; 
  }
}
