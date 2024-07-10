import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final uuid = const Uuid().v4();

final formattedDate = DateFormat.yMd();

enum Category { food, travel, education, work, leisure, others }

final categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.travel_explore,
  Category.education: Icons.school_sharp,
  Category.work: Icons.work,
  Category.leisure: Icons.leak_add,
  Category.others: Icons.more,
};

class ExpenseModel {
  ExpenseModel(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid;

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get getFormattedDate {
    return formattedDate.format(date);
  }
}
