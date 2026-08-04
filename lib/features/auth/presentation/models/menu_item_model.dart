import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item_model.freezed.dart';

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String title,
    required IconData icon,
    required String route,
    required int index,
    @Default(false) bool isDanger,
  }) = _MenuItem;
}
