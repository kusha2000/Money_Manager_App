import 'package:hive/hive.dart';
import 'package:money_manager_app/models/expense.dart';

class Database {
  //create a database reference
  final _myBox = Hive.box("expenseDatabase");

  List<ExpenseModel> expenseList = [];

  //create the init expense list function

  void createInitialDatabase() {
    expenseList = [
      ExpenseModel(
          amount: 400,
          date: DateTime.now(),
          title: "Cake",
          category: Category.food),
      ExpenseModel(
          amount: 700,
          date: DateTime.now(),
          title: "Books",
          category: Category.education)
    ];
  }

  //load the data
  void loadData() {
    final dynamic data = _myBox.get("EXP_DATA");
    //validate the data
    if (data != null && data is List<dynamic>) {
      expenseList = data.cast<ExpenseModel>().toList();
    }
  }

  //update the data
  Future<void> updateData() async {
    await _myBox.put("EXP_DATA", expenseList);
  }
}
