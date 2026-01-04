import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/cubits.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDark,
            onChanged: (val) {
              context.read<ThemeCubit>().toggleTheme(val);
            },
          ),
          const ListTile(
            title: Text("Version"),
            subtitle: Text("Proto.1.0 (Supabase Ready)"),
          ),
        ],
      ),
    );
  }
}
