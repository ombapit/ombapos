import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/widgets/main_drawer.dart';

class Settings extends StatefulWidget {
  final int initialIndex;
  const Settings({super.key, this.initialIndex = 0});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Scaffold(body: Text("Settings")),
    );
  }
}
