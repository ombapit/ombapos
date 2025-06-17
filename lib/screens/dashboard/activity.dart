import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/widgets/main_drawer.dart';

class Activity extends StatefulWidget {
  final int initialIndex;
  const Activity({super.key, this.initialIndex = 0});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Scaffold(body: Text("Activity")),
    );
  }
}
