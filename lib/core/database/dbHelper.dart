import 'package:budgeta/business%20features/select%20sms%20provider/data/sms_provider.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:budgeta/models/category.dart' as model;

class DBHelper {
  static DBHelper? _instance;

  DBHelper._();

  static DBHelper get instance {
    _instance ??= DBHelper._(); // create only once
    return _instance!;
  }

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), "transactions.db");

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE,
            isExpense INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE smsproviders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoryId INTEGER NOT NULL,
            amount REAL,
            date INTEGER,
            isExpense INTEGER NOT NULL,
            FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
            UNIQUE(categoryId, amount, date, isExpense)
          )
        ''');

        // await db.execute('''
        //   CREATE TABLE transactions (
        //     id INTEGER PRIMARY KEY AUTOINCREMENT,
        //     category TEXT,
        //     amount REAL,
        //     date INTEGER,
        //     paymenttype TEXT,
        //     note TEXT
        //   )
        // ''');
      },
    );
  }

  Future<model.Transaction> insertTransaction({
    required model.Transaction transaction,
  }) async {
    final dbClient = await db;
    final int id = await dbClient.insert(
      "transactions",
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return transaction.copyWith(id: id);
  }

  Future<void> insertTransactions(List<model.Transaction> transactions) async {
    final dbClient = await db;
    final batch = dbClient.batch();

    for (final transaction in transactions) {
      batch.insert(
        "transactions",
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> insertSMSProviders(List<SmsProvider> providers) async {
    final dbClient = await db;
    final batch = dbClient.batch();

    for (final provider in providers) {
      batch.insert('smsproviders', {
        "name": provider.name,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // await batch.commit(noResult: true);
    await batch.commit().then((results) {
      print('Batch insert results: $results');
    });
  }

  Future<List<SmsProvider>> getSmsProviders() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'smsproviders',
    );
    // return maps.toList();
    return List.generate(maps.length, (i) {
      return SmsProvider.fromMap(maps[i]);
    });
  }

  Future<void> removeSmsProvider(int id) async {
    final dbClient = await db;
    await dbClient.delete('smsproviders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeSmsProviders(List<SmsProvider> smsProviders) async {
    final dbClient = await db;
    final batch = dbClient.batch();

    for (SmsProvider sp in smsProviders) {
      batch.delete('smsproviders', where: 'id = ?', whereArgs: [sp.id]);
    }

    // commit() executes everything in one go
    await batch.commit(noResult: true);
  }

  Future<bool> deleteTransaction(int id) async {
    final dbClient = await db;
    final count = await dbClient.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<List<model.Transaction>> getTransactions() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'transactions',
    );

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<List<model.Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    //remove time part from date
    start = start.removeTimePart();
    end = end.removeTimePart();

    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'transactions',
      orderBy: 'date DESC',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<List<model.Transaction>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    //remove time part from date
    start = start.removeTimePart();
    end = end.removeTimePart();

    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'transactions',
      orderBy: 'date DESC',
      where: 'date >= ? AND date <= ? AND isExpense=1',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<void> clearTransactions() async {
    final dbClient = await db;
    await dbClient.delete('transactions');
  }

  //categories
  Future<int> insertCategory(model.Category category) async {
    final dbClient = await db;
    return await dbClient.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertCategories(List<model.Category> categories) async {
    final dbClient = await db;
    final batch = dbClient.batch();

    for (final category in categories) {
      batch.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // await batch.commit(noResult: true);
    await batch.commit().then((results) {
      print('Batch insert results: $results');
    });
  }

  Future<List<model.Category>> getCategories() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('categories');
    print("db ${maps.length}");
    return List.generate(maps.length, (i) {
      return model.Category.fromMap(maps[i]);
    });
  }

  Future<bool> categoryExists(String name) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'categories',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    return result.isNotEmpty; // true if found
  }
}

/*
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:budgeta/data/transaction.dart' as trans;

class DBHelper {
  static DBHelper? _instance;
  DBHelper._();

  static DBHelper get instance {
    _instance ??= DBHelper._();
    return _instance!;
  }

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), "transactions.db");

    return await openDatabase(
      path,
      version: 2, // 🔼 increment version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT,
        amount REAL,
        date INTEGER,
        paymenttype TEXT,
        note TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        iconPath TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          iconPath TEXT NOT NULL
        )
      ''');
    }
  }

  // ---------------- TRANSACTIONS ----------------

  Future<void> insertTransaction({
    required trans.Transaction transaction,
  }) async {
    final dbClient = await db;
    await dbClient.insert("transactions", transaction.toMap());
  }

  Future<List<trans.Transaction>> getTransactions() async {
    final dbClient = await db;
    final maps = await dbClient.query('transactions');

    return maps.map((e) => trans.Transaction.fromMap(e)).toList();
  }

  Future<void> clearTransactions() async {
    final dbClient = await db;
    await dbClient.delete('transactions');
  }

  // ---------------- CATEGORIES ----------------

  Future<void> insertCategory({
    required String name,
    required String iconPath,
  }) async {
    final dbClient = await db;
    await dbClient.insert('categories', {
      'name': name,
      'iconPath': iconPath,
    });
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final dbClient = await db;
    return await dbClient.query('categories');
  }

  Future<void> deleteCategory(int id) async {
    final dbClient = await db;
    await dbClient.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

*/
