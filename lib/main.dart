import 'package:flutter/material.dart';
import 'package:taskmaster/screens/view_expense.dart';
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
  List<Widget> screens = [ViewTask(), ViewExpense()];
  List<BottomNavigationBarItem> screenIcons = [
    BottomNavigationBarItem(icon: Icon(Icons.view_carousel), label: 'Tasks'),
    BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expenses'),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.brown,
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
