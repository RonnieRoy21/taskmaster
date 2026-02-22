import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taskmaster/models/task_model.dart';

class SqliteDatabase {
  final String _dbName = 'TaskMaster.db';
  final int _dbVersion = 1;
  //lets make a db first
  Future<Database> getTaskDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => db.execute(
        "CREATE TABLE TASKS(task_id INTEGER NOT NULL primary key,task_title text not null,task_detail text,task_due_date text not null,task_status boolean not null );",
      ),
      version: _dbVersion,
    );
  }

  Future<String> insertTask(Task task) async {
    try {
      final db = await getTaskDatabase();
      await db.insert('TASKS', task.taskToJson());
      return 'success';
    } on DatabaseException catch (err) {
      return err.result.toString();
    } catch (other) {
      return other.toString();
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final db = await getTaskDatabase();
      final taskData = await db.query("TASKS");
      final tasks = taskData.map((e) => Task.fromJson(json: e)).toList();
      return tasks;
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
      return [];
    } catch (other) {
      Fluttertoast.showToast(msg: other.toString());
      return [];
    }
  }
}
