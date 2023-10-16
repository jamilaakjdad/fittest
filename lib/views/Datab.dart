import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<void> createTables(sql.Database database) async {
    // Check if the table already exists
    final tableExists = await database.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='items'");

    if (tableExists.isEmpty) {
      // Table does not exist, create it
      await database.execute("""CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          title TEXT,
          description TEXT,
          token TEXT,
          civilite TEXT,
          createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        """);
    } else {
      // Table already exists, no need to create
      print("Table 'items' already exists");
    }
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'nabindhakal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item
  static Future<int> createItem(
      int idclt, String? title, String? descrption, String token, String civilite) async {
    final db = await DatabaseHelper.db();

    final data = {'id': idclt, 'title': title, 'description': descrption, 'token': token, 'civilite': civilite};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await DatabaseHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Update the password for all items in the table
  static Future<void> updateAllPasswords(String password) async {
    final db = await DatabaseHelper.db();

    final data = {
      'description': password,
    };

    try {
      await db.update('items', data);
    } catch (err) {
      debugPrint("Something went wrong when updating passwords: $err");
    }
  }

  static Future<void> deleteItems() async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("items");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // Get the first title from the table
  static Future<String?> getFirstTitle() async {
    final db = await DatabaseHelper.db();
    final result = await db.query('items', orderBy: "id", limit: 1);
    if (result.isNotEmpty) {
      return result.first['title'] as String?;
    }
    return null;
  }
}
