import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmaster/database/expense_databse.dart';
import 'package:taskmaster/models/expense_model.dart';
import 'package:taskmaster/reusable_widgets/reusable_widgets.dart';

Widget addExpense(BuildContext context) {
  final List<String> categories = [
    "Food",
    "Electricity",
    "Electronics",
    "Water",
    "Snacks",
    "Soft Drinks",
    "Gas(Cooking/Heating)",
    "Internet / WiFi",
    "Phone Calls / Credit",
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
    "Travelling / Fare",
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
  final TextEditingController _paymentMessageController =
      TextEditingController();
  final formManualKey = GlobalKey<FormState>();
  final formMessageKey = GlobalKey<FormState>();

  //auto filling method
  Map<String, dynamic> expenseMessageDeocoder(String msg) {
    try {
      final String confCode = msg.split(' ')[0];
      final int amountUsed = int.parse(msg.split('Ksh')[1].split('.')[0]);
      final String date = msg.split(' on ')[1].split(' at ')[0].trim();
      final String desc = msg.split(' to ')[1].split(' on ')[0];
      return {
        'payId': confCode,
        'payAmount': amountUsed,
        'payDate': date,
        'payDescription': desc,
        'error': null,
      };
    } on TypeError catch (tErr) {
      return {'error': tErr.toString()};
    } catch (err) {
      return {'error': err.toString()};
    }
  }

  return Scaffold(
    backgroundColor: Colors.lime,
    appBar: AppBar(),
    body: SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: formManualKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButtonFormField(
                  padding: EdgeInsets.all(8.0),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  dropdownColor: Colors.grey[400],
                  hint: Text('Select a Category'),
                  items: categoryItems,
                  onChanged: (newValue) {
                    _categoryController.text = newValue.toString().trim();
                  },
                  validator: (value) {
                    if (value.toString().isEmpty || value == null) {
                      return 'Pick Category';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 8),
                ReusableWidgets().textFormField(
                  8,
                  controller: _amountController,
                  readOnly: false,
                  label: 'Amount Used',
                  keyboard: TextInputType.phone,
                  action: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                ReusableWidgets().textFormField(
                  100,
                  controller: _descriptionController,
                  readOnly: false,
                  label: 'Description',
                  keyboard: TextInputType.text,
                  action: TextInputAction.next,
                ),
                const SizedBox(height: 8),
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
                const SizedBox(height: 8),
                ReusableWidgets().textFormField(
                  10,
                  controller: _confirmationNoController,
                  label: 'Payment Confirmation Number',
                  readOnly: false,
                  keyboard: TextInputType.text,
                  action: TextInputAction.done,
                ),
                Center(
                  child: Text(
                    'OR paste your payment message to autofill ',
                    style: TextStyle(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Form(
            key: formMessageKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              controller: _paymentMessageController,
              maxLines: 7,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                label: Text('Paste Message here'),
                hintText: 'Paste Message here',
                border: OutlineInputBorder(),
              ),
              onChanged: (newValue) {
                final response = expenseMessageDeocoder(newValue.toString());
                _amountController.text = response['payAmount'].toString();
                _descriptionController.text = response['payDescription'];
                _dateController.text = response['payDate']
                    .toString()
                    .replaceAll('/', '-');
                _confirmationNoController.text = response['payId'];
              },
            ),
          ),
          //the btns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!formManualKey.currentState!.validate()) {
                    ReusableWidgets().snackBar('Missing Fields', context);
                    return;
                  }
                  await ExpenseDatabse().insertExpense(
                    ExpenseModel(

                      expenseCost: double.parse(_amountController.text.trim()),
                      expenseCategory: _categoryController.text.trim(),
                      expenseConfirmationNumber: _confirmationNoController.text.trim(),
                      expenseDate: _dateController.text.trim(),
                      expenseDescription: _descriptionController.text.trim()
                    ),
                  );
                  _paymentMessageController.clear();
                  _dateController.clear();
                  _confirmationNoController.clear();
                  _categoryController.clear();
                  _descriptionController.clear();
                  _confirmationNoController.clear();
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Exit'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
