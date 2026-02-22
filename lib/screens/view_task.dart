import 'package:flutter/material.dart';
import 'package:taskmaster/database/sqlite_database.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  late final Future _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = SqliteDatabase().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Tasks')),
      body: FutureBuilder(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(child: Text('No Tasks'));
          }
          final taskList = snapshot.data! as List;
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, index) {
              final task = taskList[index];
              return InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(task.taskTitle.toString()),
                  subtitle: Text(task.taskDetail.toString()),
                  trailing: Text(task.dueDate.toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
