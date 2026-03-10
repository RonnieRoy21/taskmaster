import 'package:flutter/material.dart';
import 'package:taskmaster/database/expense_databse.dart';
import 'package:taskmaster/screens/add_expense.dart';

class ViewExpense extends StatefulWidget {
  const ViewExpense({super.key});

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              height: 150,
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
                subtitle: Text('0 Ksh', style: TextStyle(fontSize: 20)),
                trailing: Text(
                  'Expense Tracker',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addExpense(context)),
              ),
              child: Card(
                color: Colors.blue,
                child: ListTile(title: Text('Add Another')),
              ),
            ),
            Divider(thickness: 5),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: FutureBuilder(
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
                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ListTile(
                        isThreeLine: true,
                        title: Text(record.expenseCategory),
                        subtitle: Text(
                          "${record.expenseCost.toString()} Kshs\nPayment Id: ${record.expenseConfirmationNumber}",
                        ),
                        trailing: Text(record.expenseDate),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
