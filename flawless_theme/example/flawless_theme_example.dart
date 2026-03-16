import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flawless_theme/flawless_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlawlessThemeController(),
      child: Consumer<FlawlessThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            themeMode: themeController.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<FlawlessThemeController>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Flawless Theme Example')),
      body: Center(
        child: DropdownButton<ThemeMode>(
          value: themeController.themeMode,
          items: ThemeMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(mode.toString().split('.').last),
            );
          }).toList(),
          onChanged: (mode) {
            if (mode != null) themeController.setThemeMode(mode);
          },
        ),
      ),
    );
  }
}
