import 'package:kalender/kalender.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'calendar_state.dart';

part 'calendar_notifier.g.dart';

/// Manages view/body/header/interaction config that needs to persist
/// across widget rebuilds (e.g. sidebar config panel changes).
@riverpod
class CalendarConfigNotifier extends _$CalendarConfigNotifier {
  @override
  CalendarConfig build() => CalendarConfig();

  void setViewConfiguration(ViewConfiguration value) {
    if (state.viewConfiguration == value) return;
    state = state.copyWith(viewConfiguration: value);
  }

  void setMultiDayBodyConfiguration(MultiDayBodyConfiguration value) {
    if (state.multiDayBodyConfiguration == value) return;
    state = state.copyWith(multiDayBodyConfiguration: value);
  }

  void setMultiDayHeaderConfiguration(MultiDayHeaderConfiguration value) {
    if (state.multiDayHeaderConfiguration == value) return;
    state = state.copyWith(multiDayHeaderConfiguration: value);
  }

  void setMonthBodyConfiguration(MonthBodyConfiguration value) {
    if (state.monthBodyConfiguration == value) return;
    state = state.copyWith(monthBodyConfiguration: value);
  }

  void setScheduleBodyConfiguration(ScheduleBodyConfiguration value) {
    if (state.scheduleBodyConfiguration == value) return;
    state = state.copyWith(scheduleBodyConfiguration: value);
  }

  void setInteractionBody(CalendarInteraction value) {
    if (state.interactionBody == value) return;
    state = state.copyWith(interactionBody: value);
  }

  void setInteractionHeader(CalendarInteraction value) {
    if (state.interactionHeader == value) return;
    state = state.copyWith(interactionHeader: value);
  }

  void setSnapping(CalendarSnapping value) {
    if (state.snapping == value) return;
    state = state.copyWith(snapping: value);
  }

  void setShowHeader(bool value) {
    if (state.showHeader == value) return;
    state = state.copyWith(showHeader: value);
  }
}


