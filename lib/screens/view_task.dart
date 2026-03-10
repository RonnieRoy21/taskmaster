import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskmaster/database/task_database.dart';
import 'package:taskmaster/models/task_model.dart';

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

  Future onRefreshMethod() async {
    _tasksFuture = SqliteDatabase().getTasks();
  }

  void showDetails({required Task task}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInOutCubic,
        duration: Duration(seconds: 1),
      ),
      builder: (context) {
        return AlertDialog(
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title :\n ${task.taskTitle}'),
                const SizedBox(height: 8.0),
                Text('Description :\n ${task.taskDetail}'),
                const SizedBox(height: 8.0),
                Text('Due on :\n ${task.dueDate}'),
                const SizedBox(height: 8.0),
                (task.taskStatus == false)
                    ? Text('Status ---> Pending')
                    : Text('Status ---> Done'),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (task.taskId == null) {
                          Fluttertoast.showToast(msg: " Can't find id");
                        }
                        SqliteDatabase().markTaskAsDone(id: task.taskId!);
                        Fluttertoast.showToast(msg: 'Marked as Done');
                        Navigator.pop(context);
                      },
                      child: Text('Mark as Done'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(centerTitle: true, title: Text('Tasks')),
      body: RefreshIndicator(
        onRefresh: () => onRefreshMethod(),
        child: FutureBuilder(
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
                  customBorder: Border.all(),
                  onTap: () => showDetails(task: task),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          iconColor: Colors.red,
                          icon: Icon(Icons.delete),
                          title: Text('Delete Task ?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    SqliteDatabase().deleteTask(
                                      id: task.taskId,
                                    );
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: Text('Delete'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text(task.taskTitle.toString()),
                    subtitle: Text(task.dueDate.toString()),
                    trailing: Text('Done ? : ${task.taskStatus.toString()}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
