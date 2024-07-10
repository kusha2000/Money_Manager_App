import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart';

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

@HiveType(typeId: 1)
class ExpenseModel {
  ExpenseModel(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid;

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  String get getFormattedDate {
    return formattedDate.format(date);
  }
}
