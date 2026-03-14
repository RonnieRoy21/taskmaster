class ExpenseModel {
  String expenseConfirmationNumber, expenseDate, expenseCategory,expenseDescription;
  double expenseCost;

  ExpenseModel({
    required this.expenseCost,
    required this.expenseCategory,
    required this.expenseConfirmationNumber,
    required this.expenseDate,
    required this.expenseDescription
  });

  factory ExpenseModel.fromJson({required Map<String, dynamic> json}) {
    return ExpenseModel(
      expenseDescription: json['expense_description'],
      expenseCost: json['expense_cost'],
      expenseCategory: json['expense_category'],
      expenseConfirmationNumber: json['expense_confirmation_number'],
      expenseDate: json['expense_date'],
    );
  }

  Map<String, dynamic> expenseToJson() => {
    'expense_description':expenseDescription,
    'expense_cost': expenseCost,
    'expense_category': expenseCategory,
    'expense_date': expenseDate,
    'expense_confirmation_number': expenseConfirmationNumber,
  };

 
}
