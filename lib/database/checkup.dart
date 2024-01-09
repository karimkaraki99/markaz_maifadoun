import 'package:flutter/material.dart';

class CheckupFormItem {
  final String name;
  final bool type;

  CheckupFormItem({required this.name, required this.type});

  factory CheckupFormItem.fromJson(Map<String, dynamic> json) {
    return CheckupFormItem(
      name: json['name'] ?? '',
      type: json['type'] ?? false,
    );
  }
}

class CheckupForm {
  final List<CheckupFormItem> items;

  CheckupForm({required this.items});

  factory CheckupForm.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawItems = json['checkup-form'] ?? [];
    List<CheckupFormItem> items = rawItems
        .map((rawItem) => CheckupFormItem.fromJson(rawItem as Map<String, dynamic>))
        .toList();

    return CheckupForm(items: items);
  }
}
