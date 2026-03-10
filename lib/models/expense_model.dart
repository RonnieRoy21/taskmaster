
class ExpenseModel {
  String  expenseConfirmationNumber, expenseDate, expenseCategory;
  double expenseCost;

  ExpenseModel({
    required this.expenseCost,
    required this.expenseCategory,
    required this.expenseConfirmationNumber,
    required this.expenseDate,
  });

  factory ExpenseModel.fromJson({required Map<String, dynamic> json}) {
    return ExpenseModel(
      expenseCost: json['expense_cost'],
      expenseCategory: json['expense_category'],
      expenseConfirmationNumber: json['expense_confirmation_number'],
      expenseDate: json['expense_date'],
    );
  }

  Map<String, dynamic> expenseToJson() => {
    'expense_cost': expenseCost,
    'expense_category': expenseCategory,
    'expense_date': expenseDate,
    'expense_confirmation_number': expenseConfirmationNumber,
  };
}
