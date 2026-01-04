import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Settings extends Equatable {
  final ThemeMode themeMode;

  const Settings({required this.themeMode});

  factory Settings.initial() {
    return const Settings(themeMode: ThemeMode.system);
  }

  Settings copyWith({ThemeMode? themeMode, String? libraryPath}) {
    return Settings(themeMode: themeMode ?? this.themeMode);
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(themeMode: _parseThemeMode(json['theme_mode']));
  }

  Map<String, dynamic> toJson() {
    return {'theme_mode': themeMode.name};
  }

  static ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  List<Object?> get props => [themeMode];
}
