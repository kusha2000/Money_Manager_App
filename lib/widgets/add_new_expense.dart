import 'package:flutter/material.dart';
import 'package:money_manager_app/models/expense.dart';
import 'package:intl/intl.dart';

final formattedDate = DateFormat.yMd();

class AddNewExpense extends StatefulWidget {
  final void Function(ExpenseModel expense) onAddExpense;
  const AddNewExpense({super.key, required this.onAddExpense});

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.education;

  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  DateTime _selectedDate = DateTime.now();

  Future<void> _openDateModal() async {
    try {
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate);

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _handleFormSubmit() {
    double? userAmount;
    try {
      userAmount = double.parse(_amountController.text.trim());
    } catch (e) {
      userAmount = null;
    }

    if (_titleController.text.trim().isEmpty ||
        userAmount == null ||
        userAmount <= 0) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Enter valid Data"),
              content: const Text(
                  "Please enter valid data for the title and the amount here the title can't be empty and the amount can't be less than zero"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"))
              ],
            );
          });
    } else {
      ExpenseModel newExpense = ExpenseModel(
          amount: userAmount,
          category: _selectedCategory,
          date: _selectedDate,
          title: _titleController.text.trim());

      widget.onAddExpense(newExpense);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new Expense title",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate.format(_selectedDate)),
                    IconButton(
                      onPressed: _openDateModal,
                      icon: const Icon(Icons.date_range_outlined),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (Category) => DropdownMenuItem(
                            value: Category, child: Text(Category.name)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  }),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.redAccent)),
                    child: const Text("Close"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: _handleFormSubmit,
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.greenAccent)),
                    child: const Text("Save"),
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
