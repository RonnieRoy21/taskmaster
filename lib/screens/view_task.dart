import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskmaster/database/task_database.dart';
import 'package:taskmaster/models/task_model.dart';
import 'package:taskmaster/screens/add_task.dart';

class ViewTask extends StatefulWidget {
  const ViewTask({super.key});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  late Future<List<Task>> tasksFuture;
  int numberTasks = 0;

  Future<List<Task>> _tasksFuture() async {
    return await SqliteDatabase().getTasks();
  }

  @override
  void initState() {
    super.initState();
    tasksFuture = _tasksFuture();
    countTodaysTasks();
  }

  Future<void> countTodaysTasks() async {
    final number = await SqliteDatabase().getTodaysTasks();
    setState(() {
      numberTasks = number;
    });
  }

  void refreshTasks() {
    setState(() {
      tasksFuture = _tasksFuture();
    });
    countTodaysTasks();
  }

  void showDetails({required Task task}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title :\n ${task.taskTitle}'),
                const SizedBox(height: 8),

                Text('Description :\n ${task.taskDetail}'),
                const SizedBox(height: 8),

                Text('Due on :\n ${task.dueDate}'),
                const SizedBox(height: 8),

                (task.taskStatus == false)
                    ? const Text('Status ---> Pending')
                    : const Text('Status ---> Done'),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (task.taskId == null) {
                          Fluttertoast.showToast(msg: "Can't find id");
                          return;
                        }

                        await SqliteDatabase().markTaskAsDone(id: task.taskId!);

                        Fluttertoast.showToast(msg: 'Marked as Done');

                        Navigator.pop(context);

                        refreshTasks();
                      },
                      child: const Text('Mark as Done'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void deletedTask({required int id}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          iconColor: Colors.red,
          icon: const Icon(Icons.delete),
          title: const Text('Delete Task ?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await SqliteDatabase().deleteTask(id: id);

                    Navigator.pop(context);

                    refreshTasks();
                  },
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(centerTitle: true, title: const Text('Tasks')),

      body: FutureBuilder(
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final List<Task> taskList = snapshot.data ?? [];

          if (taskList.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: ListTile(
                    title: Text("Today's Incomplete Tasks : $numberTasks"),
                  ),
                ),

                const Divider(thickness: 1, color: Colors.brown),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddTask()),
                    ).whenComplete(() => refreshTasks());
                  },
                  child: const Card(
                    color: Colors.green,
                    child: ListTile(title: Text('Add a Task')),
                  ),
                ),

                const Divider(thickness: 1, color: Colors.brown),

                const Expanded(child: Center(child: Text('No Tasks'))),
              ],
            );
          }

          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListTile(
                  title: Text("Today's Incomplete Tasks : $numberTasks"),
                ),
              ),

              const Divider(thickness: 1, color: Colors.brown),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTask()),
                  ).whenComplete(() => refreshTasks());
                },
                child: const Card(
                  color: Colors.green,
                  child: ListTile(title: Text('Add a Task')),
                ),
              ),

              const Divider(thickness: 1, color: Colors.brown),

              Expanded(
                child: ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];

                    return InkWell(
                      onTap: () => showDetails(task: task),
                      onLongPress: () => deletedTask(id: task.taskId!),

                      child: ListTile(
                        title: Text(task.taskTitle),
                        subtitle: Text(task.dueDate),

                        trailing: (task.taskStatus == false)
                            ? const Text('Pending')
                            : const Text('Done'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
