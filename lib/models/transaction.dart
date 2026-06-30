import 'package:budgeta/models/category.dart' as model;
import 'package:budgeta/models/category_factory.dart';

class Transaction {
  final int id;
  double amount;
  DateTime datetime;
  model.Category category;

  Transaction({
    required this.id,
    required this.amount,
    required this.datetime,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': category.id, //string
      'amount': amount, //double
      'date': datetime.millisecondsSinceEpoch, //int
      'isExpense': category.isExpense ? 1 : 0,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    int categoryId = map['categoryId'] as int;
    final model.Category? category = CategoryFactory.getCategoryById(
      categoryId,
    );
    if (category == null) {
      throw Exception('Category $categoryId not loaded');
    }
    return Transaction(
      id: map['id'] as int,
      // categoryId: categoryId,
      amount: map['amount'] as double,
      datetime: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      category: category,
      // isExpense: (map['isExpense'] as int) == 1 ? true : false,
    );
  }

  Transaction copyWith({
    int? id,
    double? amount,
    DateTime? datetime,
    model.Category? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      // categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      datetime: datetime ?? this.datetime,
      category: category ?? this.category,
    );
  }
}
