class Task {
  final String taskDetail, taskTitle, dueDate;
  final bool taskStatus;
  final int? taskId;

  Task(this.taskId,{
    required this.taskDetail,
    required this.taskTitle,
    required this.dueDate,
    required this.taskStatus,
  });

  factory Task.fromJson({required Map<String, dynamic> json}) {
    return Task(
      json['task_id'],
      taskTitle: json['task_title'].toString(),
      taskDetail: json['task_detail'] ?? "None",
      dueDate: json['task_due_date'].toString(),
      taskStatus: (json['task_status'] as int) == 1,
    );
  }
  Map<String, dynamic> taskToJson() => {
    'task_title': taskTitle.toString(),
    'task_detail': taskDetail.toString(),
    'task_due_date': dueDate.toString(),
    'task_status': taskStatus,
  };
}
