import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Creating mock data for a weekly schedule starting from today
    final List<_Shift> shifts = _generateMockShifts();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Schedule"),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Weekly Hours",
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "36.5 Hrs",
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Role: Front Desk Receptionist",
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Upcoming Shifts",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final shift = shifts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildShiftCard(context, shift, theme, isDark),
                  );
                },
                childCount: shifts.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)), // SafeArea
        ],
      ),
    );
  }

  Widget _buildShiftCard(BuildContext context, _Shift shift, ThemeData theme, bool isDark) {
    final bool isToday = shift.date.day == DateTime.now().day && shift.date.month == DateTime.now().month;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.3) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isToday ? theme.colorScheme.primary.withOpacity(0.5) : theme.dividerColor.withOpacity(0.1),
          width: isToday ? 2 : 1,
        ),
        boxShadow: !isDark ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Column
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isToday ? theme.colorScheme.primary.withOpacity(0.1) : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  _getWeekday(shift.date).toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shift.date.day.toString().padLeft(2, '0'),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: isToday ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Shift Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isToday)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "TODAY",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                Text(
                  shift.timeRange,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      shift.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Hours token
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${shift.hours}h",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<_Shift> _generateMockShifts() {
    final now = DateTime.now();
    return [
      _Shift(date: now, timeRange: "09:00 AM - 05:00 PM", hours: 8.0, location: "Main floor - Front Desk"),
      _Shift(date: now.add(const Duration(days: 1)), timeRange: "10:00 AM - 04:00 PM", hours: 6.0, location: "Main floor - Front Desk"),
      _Shift(date: now.add(const Duration(days: 2)), timeRange: "02:00 PM - 10:00 PM", hours: 8.0, location: "Main floor - Hosts Stand"),
      _Shift(date: now.add(const Duration(days: 4)), timeRange: "09:00 AM - 05:00 PM", hours: 8.0, location: "Main floor - Front Desk"),
      _Shift(date: now.add(const Duration(days: 5)), timeRange: "12:00 PM - 06:30 PM", hours: 6.5, location: "Main floor - Front Desk"),
    ];
  }

  String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}

class _Shift {
  final DateTime date;
  final String timeRange;
  final double hours;
  final String location;

  _Shift({
    required this.date,
    required this.timeRange,
    required this.hours,
    required this.location,
  });
}
