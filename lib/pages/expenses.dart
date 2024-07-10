import 'package:flutter/material.dart';
import 'package:money_manager_app/models/expense.dart';
import 'package:money_manager_app/widgets/add_new_expense.dart';
import 'package:money_manager_app/widgets/expenses_list.dart';
import 'package:pie_chart/pie_chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<ExpenseModel> _expenseList = [
    ExpenseModel(
        amount: 12.5,
        date: DateTime.now(),
        title: "Cake",
        category: Category.food),
    ExpenseModel(
        amount: 10,
        date: DateTime.now(),
        title: "Books",
        category: Category.education)
  ];

  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Education": 0,
    "Leisure": 0,
    "Work": 0,
    "Others": 0,
  };

  void onAddNewExpense(ExpenseModel expense) {
    setState(() {
      _expenseList.add(expense);
      calCategoryValues();
    });
  }

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddNewExpense(
            onAddExpense: onAddNewExpense,
          );
        });
  }

  void onDeleteExpense(ExpenseModel expense) {
    ExpenseModel deletingExpense = expense;
    final int removingIndex = _expenseList.indexOf(expense);
    setState(() {
      _expenseList.remove(expense);
      calCategoryValues();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Sucessfully"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _expenseList.insert(removingIndex, deletingExpense);
                calCategoryValues();
              });
            }),
      ),
    );
  }

  double foodVal = 0;
  double travelVal = 0;
  double educationVal = 0;
  double leisureVal = 0;
  double workVal = 0;
  double othersVal = 0;

  void calCategoryValues() {
    double foodValTotal = 0;
    double travelValTotal = 0;
    double educationValTotal = 0;
    double leisureValTotal = 0;
    double workValTotal = 0;
    double othersValTotal = 0;

    for (final expense in _expenseList) {
      if (expense.category == Category.food) {
        foodValTotal += expense.amount;
      }
      if (expense.category == Category.education) {
        educationValTotal += expense.amount;
      }
      if (expense.category == Category.leisure) {
        leisureValTotal += expense.amount;
      }
      if (expense.category == Category.travel) {
        travelValTotal += expense.amount;
      }
      if (expense.category == Category.work) {
        workValTotal += expense.amount;
      }
      if (expense.category == Category.others) {
        othersValTotal += expense.amount;
      }
    }

    setState(() {
      foodVal = foodValTotal;
      travelVal = travelValTotal;
      educationVal = educationValTotal;
      leisureVal = leisureValTotal;
      workVal = workValTotal;
      othersVal = othersValTotal;
    });

    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Education": educationVal,
      "Leisure": leisureVal,
      "Work": workVal,
      "Others": othersVal,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calCategoryValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Money Manager"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Container(
            color: Color(0xFF1abc9c),
            child: IconButton(
              onPressed: _openAddExpensesOverlay,
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Container(
        color: Color(0xFF0e1523),
        child: Column(
          children: [
            PieChart(dataMap: dataMap),
            ExpenseList(
              expenseList: _expenseList,
              onDeleteExpense: onDeleteExpense,
            )
          ],
        ),
      ),
    );
  }
}
