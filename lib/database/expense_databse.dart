import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/models/expense_model.dart';

class ExpenseDatabse {
  //variables
  final String _dbName = 'Expense.db';
  final int _dbVersion = 1;
  //init db
  Future<Database> getExpenseDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => db.execute(
        'CREATE TABLE EXPENSES (expense_confirmation_number TEXT PRIMARY KEY ,expense_cost FLOAT NOT NULL,expense_date TEXT NOT NULL,expense_category TEXT NOT NULL,expense_description TEXT NOT NULL)',
      ),
      version: _dbVersion,
    );
  }

  //add expense
  Future<void> insertExpense(ExpenseModel expense) async {
    final db = await getExpenseDatabase();
    try {
      await db.insert('EXPENSES', expense.expenseToJson());
      Fluttertoast.showToast(msg: 'Expense Added');
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error Occurred');
    } finally {
      db.close();
    }
  }

  //get expense
  Future<List<ExpenseModel>> getExpenses() async {
    final db = await getExpenseDatabase();
    try {
      final expenseList = await db.query('EXPENSES');
      final expenses = expenseList
          .map((e) => ExpenseModel.fromJson(json: e))
          .toList();
      return expenses;
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
      return [];
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error Occurred');
      return [];
    } finally {
      db.close();
    }
  }

  Future<double> monthlySpend() async {
    final db = await getExpenseDatabase();

    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0'); 
    final mnth = now.month.toString(); 

    double cost = 0;

    try {
      final List<Map<String, dynamic>> response = await db.query(
        'EXPENSES',
        columns: ['expense_cost'],
        where: " expense_date LIKE ? OR expense_date LIKE ?",
        whereArgs: ['%-$mnth-%', '%-$month-%'],
      );


      for (final row in response) {
        final totalCost = row['expense_cost'] as num;
        cost += totalCost.toDouble();
      }
      return cost;
    } catch (err) {
      Fluttertoast.showToast(msg: err.toString());
      return cost;
    }
  }

  //delete expense
  Future<void> deleteExpense({
    required String expenseConfirmationNumber,
  }) async {
    final db = await getExpenseDatabase();
    try {
      await db.delete(
        'EXPENSES',
        where: 'expense_confirmation_number = ?',
        whereArgs: [expenseConfirmationNumber],
      );
      Fluttertoast.showToast(msg: 'Deleted');
    } on DatabaseException catch (dbErr) {
      Fluttertoast.showToast(msg: dbErr.result.toString());
    } catch (err) {
      Fluttertoast.showToast(msg: 'Error Occurred');
    } finally {
      db.close();
    }
  }
}
