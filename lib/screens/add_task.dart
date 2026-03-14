import 'package:flutter/material.dart';
import 'package:taskmaster/database/task_database.dart';
import 'package:taskmaster/models/task_model.dart';
import 'package:taskmaster/reusable_widgets/reusable_widgets.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //date picker
  Future<DateTime?> datePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2080),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber[300],
            border: BoxBorder.all(width: 2, style: BorderStyle.solid),
          ),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Tab(
                    text: 'Create A Task Really Quick',
                    icon: Icon(Icons.task),
                  ),
                  const SizedBox(height: 15),
                  ReusableWidgets().textFormField(
                    20,
                    readOnly: false,
                    label: 'Title',
                    keyboard: TextInputType.text,
                    action: TextInputAction.next,
                    controller: _titleController,
                  ),
                  const SizedBox(height: 20),
                  ReusableWidgets().textFormField(
                    40,
                    readOnly: false,
                    label: 'Description',
                    keyboard: TextInputType.text,
                    action: TextInputAction.next,
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: 20),
                  ReusableWidgets().textFormField(
                    20,
                    onTap: () async {
                      final date = await datePicker(context);
                      if (date != null) {
                        setState(() {
                          _dateController.text = date.toString().split(' ')[0];
                        });
                      }
                    },
                    readOnly: true,
                    label: 'Set Due Date',
                    keyboard: TextInputType.text,
                    action: TextInputAction.done,
                    controller: _dateController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await SqliteDatabase().insertTask(
                              Task(
                                null,
                                taskDetail: _descriptionController.text,
                                taskTitle: _titleController.text,
                                dueDate: _dateController.text,
                                taskStatus: false,
                              ),
                            );

                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _dateController.clear();
                          _descriptionController.clear();
                          _titleController.clear();
                        },
                        child: Text('Clear'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
