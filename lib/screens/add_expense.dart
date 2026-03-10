import 'package:flutter/material.dart';
import 'package:taskmaster/database/expense_databse.dart';
import 'package:taskmaster/models/expense_model.dart';
import 'package:taskmaster/reusable_widgets/reusable_widgets.dart';

Widget addExpense(BuildContext context) {
  final List<String> categories = [
    "Electricity",
    "Water",
    "Gas(Cooking/Heating)",
    "Internet / WiFi",
    "Cable TV / Streaming TV",
    "Garbage Collection",
    "Sewer Services",
    "Solar Power Maintenance",
    "Generator Fuel",
    "Maintenance",
    "Home Security System",
    "Landline Phone Service",
    "Community Service Charges",
    "Smart Home Services",
  ];
  final List<DropdownMenuItem<String>> categoryItems = categories.map((
    category,
  ) {
    return DropdownMenuItem<String>(value: category, child: Text(category));
  }).toList();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _confirmationNoController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();
  return Scaffold(
    backgroundColor: Colors.lime,
    appBar: AppBar(),
    body: SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(border: OutlineInputBorder()),
              dropdownColor: Colors.grey,
              hint: Text('Select a Category'),
              items: categoryItems,
              onChanged: (newValue) {
                _categoryController.text = newValue.toString();
              },
            ),
            const SizedBox(height: 16),
            ReusableWidgets().textFormField(
              8,
              controller: _amountController,
              readOnly: false,
              label: 'Amount Used',
              keyboard: TextInputType.phone,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            ReusableWidgets().textFormField(
              8,
              controller: _descriptionController,
              readOnly: false,
              label: 'Description',
              keyboard: TextInputType.text,
              action: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.always,
              controller: _dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select Date',
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2090),
                  currentDate: DateTime.now(),
                );

                _dateController.text = date.toString().split(' ')[0];
              },
            ),
            const SizedBox(height: 10),
            ReusableWidgets().textFormField(
              10,
              controller: _confirmationNoController,
              label: 'Payment Confirmation Number',
              readOnly: false,
              keyboard: TextInputType.text,
              action: TextInputAction.done,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await ExpenseDatabse().insertExpense(
                      ExpenseModel(
                        expenseCost: double.parse(
                          _amountController.text.trim(),
                        ),
                        expenseCategory: _categoryController.text,
                        expenseConfirmationNumber:
                            _confirmationNoController.text,
                        expenseDate: _dateController.text,
                      ),
                    );
                  },
                  child: Text('Save'),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Exit')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
