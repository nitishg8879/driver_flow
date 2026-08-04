import 'package:flutter/material.dart';

import '../widgets/calendar/calendar_widget.dart';

/// Full-screen calendar. No app bar — the navigation header is embedded inside CalendarWidget.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CalendarWidget());
  }
}
