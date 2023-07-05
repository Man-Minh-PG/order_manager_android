
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io' as io;


//https://www.youtube.com/watch?v=noi6aYsP7Go
// https://www.youtube.com/watch?v=xWt7dwcR1jo

// forgerin key 
// https://www.youtube.com/watch?v=lLqPIulkQYg
class DatabaseHelper { 
  static Database? _db;

  Future<Database?> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDatabase(); 
    return null;
  } 

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path  = join(documentDirectory.path, 'bachutha.db');
    var db = await sql.openDatabase(path , version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
      await db.execute(""" CREATE TABLE products(
          id         INTEGER PRIMARY KEY AUTOINCREMENT,
          name       STRING NOT NULL,
          price      REAL NOT NULL,
          status     INTEGER,
          created_at TEXT NOT NULL
      )
    """);// Để xuống dòng được mà không bị sai thì dùng cặp dấu này nhá

      await db.execute(""" CREATE TABLE orders (
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          total       REAL NOT NULL,
          note        TEXT NOT NULL,
          payment_id  INTEGER,
          status      INTEGER, 
          created_at  TEXT NOT NULL
      )
    """);// Để xuống dòng được mà không bị sai thì dùng cặp dấu này nhá

    await db.execute(""" CREATE TABLE order_detail (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id    INTEGER,
          order_id      INTEGER,
          amount        INTEGER,
          status        INTEGER, 
          created_at    TEXT NOT NULL,
          FOREIGN KEY (FK_contact_category) REFERENCES products (id) 
      )
    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá

    await db.execute(""" CREATE TABLE payment(
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          name        TEXT NOT NULL,
          note        TEXT,
          status      INTEGER,
          created_at  TEXT NOT NULL
      )
    """);// Để xuống dòng được mà không bị sai thì dùng cặp dấu này nhá
    
    await db.execute(""" CREATE TABLE generic(
          id         INTEGER PRIMARY KEY AUTOINCREMENT,
          name       TEXT NOT NULL,
          value      TEXT,
          status     INTEGER,
          created_at TEXT NOT NULL
      )
    """);// Để xuống dòng được mà không bị sai thì dùng cặp dấu này nhá
    }

  // DatabaseHelper._privateConstructor();
  // static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // static Database? _database;
  // Future<Database> get database async => _database ?? = await _initDatabase();

  // static Future<void> createTables(sql.Database database) async {
  //   await database.execute(""" CREATE TABLE products(
  //     id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  //     title TEXT
  //     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP   
  //   )
  // """);
  // }
}
