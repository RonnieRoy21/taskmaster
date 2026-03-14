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

  Future<void> insertTask(Task task) async {
    final db = await getTaskDatabase();
    try {
      await db.insert('TASKS', task.taskToJson());
      Fluttertoast.showToast(msg: 'Added');
    } on DatabaseException catch (err) {
      if (err.isDuplicateColumnError()) {
        Fluttertoast.showToast(
          msg: 'Error : One or  more similar detail xist ',
        );
      } else if (err.isNotNullConstraintError()) {
        Fluttertoast.showToast(msg: 'Error.Null value detected');
      } else if (err.isDatabaseClosedError()) {
        Fluttertoast.showToast(msg: 'Storage unreachable ');
      }
    } catch (other) {
      Fluttertoast.showToast(msg: 'Task not Added ');
    } finally {
      db.close();
    }
  }

  Future<List<Task>> getTasks() async {
    final db = await getTaskDatabase();
    try {
      final taskData = await db.query("TASKS");
      final tasks = taskData.map((e) => Task.fromJson(json: e)).toList();
      return tasks;
    } on DatabaseException catch (dbErr) {
      print('database err : ${dbErr.result}');
      Fluttertoast.showToast(
        msg: 'Database Error : ${dbErr.result.toString()}',
      );
      return [];
    } catch (other) {
      Fluttertoast.showToast(msg: 'Err : ${other.toString()}');
      return [];
    } finally {
      db.close();
    }
  }

  Future<int> getTodaysTasks() async {
    final db = await getTaskDatabase();
    final todaysDate = DateTime.now().toString().split(' ')[0];
    try {
      final tasks = await db.query(
        'TASKS',
        where: 'task_due_date = ? AND task_status = ?',
        whereArgs: [todaysDate, 0],
      );
      final numberOfTasks = tasks.length;
      return numberOfTasks;
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
      return 0;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return 0;
    } finally {
      db.close();
    }
  }

  Future<void> markTaskAsDone({required int id}) async {
    final db = await getTaskDatabase();
    try {
      await db.update(
        "TASKS",
        {'task_status': true},
        where: 'task_id = ?',
        whereArgs: [id],
      );
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    } finally {
      db.close();
    }
  }

  Future<void> deleteTask({required int id}) async {
    final db = await getTaskDatabase();
    try {
      await db.delete("TASKS", where: 'task_id= ?', whereArgs: [id]);
      Fluttertoast.showToast(msg: 'Deleted');
    } on DatabaseException catch (dbError) {
      Fluttertoast.showToast(msg: dbError.result.toString());
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    } finally {
      db.close();
    }
  }
}
