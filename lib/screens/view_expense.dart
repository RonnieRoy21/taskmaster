import 'package:flutter/material.dart';
import 'package:taskmaster/database/expense_databse.dart';
import 'package:taskmaster/models/expense_model.dart';
import 'package:taskmaster/screens/add_expense.dart';

class ViewExpense extends StatefulWidget {
  const ViewExpense({super.key});

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  double newCost = 0;

  void getMonthlyspend() async {
    final double cost = await ExpenseDatabse().monthlySpend();
    newCost = cost;
  }

  @override
  void initState() {
    super.initState();
    getMonthlyspend();
  }

  @override
  Widget build(BuildContext context) {
    void deleteExpense({required ExpenseModel exp}) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete Record with ID ${exp.expenseConfirmationNumber}',
            ),
            content: ListTile(
              title: Text(exp.expenseCategory),
              subtitle: Text(exp.expenseCost.toString()),
            ),
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await ExpenseDatabse().deleteExpense(
                        expenseConfirmationNumber:
                            exp.expenseConfirmationNumber,
                      );
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    getMonthlyspend();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Expenses')),
      body: FutureBuilder(
        future: ExpenseDatabse().getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No Records Found'));
          }
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final records = snapshot.data!;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.yellow,
                      Colors.blueAccent,
                      Colors.amber,
                    ],
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.money, size: 40.0),
                  title: Text('Total Expenditure This Month'),
                  subtitle: Text(
                    '${newCost.toString()} Ksh',
                    style: TextStyle(fontSize: 20),
                  ),
                  trailing: Text(
                    'Expense Tracker',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addExpense(context)),
                ).whenComplete(() => setState(() {})),

                child: Card(
                  color: Colors.blue,
                  child: ListTile(title: Text('Add Another')),
                ),
              ),
              Divider(thickness: 1),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Column(
                      children: [
                        ListTile(
                          isThreeLine: true,
                          title: Text(record.expenseCategory),
                          subtitle: Text(
                            "${record.expenseCost.toString()} Kshs\nPayment Id: ${record.expenseConfirmationNumber}\n${record.expenseDescription}",
                          ),
                          trailing: Text(record.expenseDate),
                          onLongPress: () => deleteExpense(exp: record),
                        ),
                        Divider(thickness: 0.8, color: Colors.blue),
                      ],
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
