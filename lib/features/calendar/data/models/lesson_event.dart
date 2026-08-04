import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';


class LessonEvent extends CalendarEvent {
  final String title;
  final String? description;
  final Color? color;

  LessonEvent({
    super.id,
    required super.dateTimeRange,
    required this.title,
    this.description,
    this.color,
    super.interaction,
    super.multiDayRule,
  });

  static const defaultColor = Color(0xFF6366F1);

  @override
  LessonEvent copyWith({
    DateTimeRange? dateTimeRange,
    EventInteraction? interaction,
    String? title,
    String? description,
    Color? color,
  }) =>
      LessonEvent(
        id: id,
        dateTimeRange: dateTimeRange ?? this.dateTimeRange,
        interaction: interaction ?? this.interaction,
        multiDayRule: multiDayRule,
        title: title ?? this.title,
        description: description ?? this.description,
        color: color ?? this.color,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return super == other &&
        other is LessonEvent &&
        other.title == title &&
        other.description == description &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, title, description, color);
}
