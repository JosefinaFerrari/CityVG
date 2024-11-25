// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    this.width,
    this.height,
    this.action,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Future Function(DateTime startDay, DateTime endDay)? action;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) =>
          (day == _selectedStartDate || day == _selectedEndDate),
      rangeStartDay: _selectedStartDate,
      rangeEndDay: _selectedEndDate,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.green.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: Colors.green.withOpacity(0.2),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: FlutterFlowTheme.of(context).primary,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: FlutterFlowTheme.of(context).primary,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_selectedStartDate == null ||
              (_selectedStartDate != null && _selectedEndDate != null)) {
            // Reset selection if both dates are selected
            _selectedStartDate = selectedDay;
            _selectedEndDate = null;
          } else if (_selectedStartDate != null && _selectedEndDate == null) {
            // Set the second date
            if (selectedDay.isAfter(_selectedStartDate!) ||
                selectedDay == _selectedStartDate) {
              _selectedEndDate = selectedDay;

              // Call the action if provided
              if (widget.action != null) {
                widget.action!(_selectedStartDate!, _selectedEndDate!);
              }
            } else {
              // Reset if the second date is before the first
              _selectedStartDate = selectedDay;
              _selectedEndDate = null;
            }
          }
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
