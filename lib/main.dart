import 'package:flutter/material.dart';
import 'package:taskmaster/screens/add_task.dart';
import 'package:taskmaster/screens/view_task.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Main()));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _Main();
}

class _Main extends State<Main> {
  List<Widget> screens = [AddTask(), ViewTask()];
  List<BottomNavigationBarItem> screenIcons = [
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Task'),
    BottomNavigationBarItem(
      icon: Icon(Icons.view_carousel),
      label: 'View Tasks',
    ),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: screenIcons,
      ),
    );
  }
}
