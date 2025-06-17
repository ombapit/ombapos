import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ombapos/widgets/main_drawer.dart';

class Shift extends StatefulWidget {
  final int initialIndex;
  const Shift({super.key, this.initialIndex = 0});

  @override
  State<Shift> createState() => _ShiftState();
}

class _ShiftState extends State<Shift> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shift"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Scaffold(body: Text("Shift")),
    );
  }
}
