import 'dart:io' ;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/*
 integers 0 (false) and 1 (true).
 */
class DatabaseRepository { 
  DatabaseRepository.privateConstructor();

  static final DatabaseRepository instance =
    DatabaseRepository.privateConstructor();

  final _databaseName    = 'bachutha';
  final _databaseVersion = 1;  

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
    }
    return null;
  } 

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: onCreate);
  }

  // Create Database
  Future onCreate(Database db, int version) async {
    await db.execute(""" CREATE TABLE product(
          id         INTEGER PRIMARY KEY AUTOINCREMENT,
          name       STRING NOT NULL,
          price      REAL NOT NULL,
          status     INTEGER,
          created_at TEXT NOT NULL,
          disable    BOOLEAN DEFAULT 0
      )
    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá
    
    await db.execute(""" CREATE TABLE payment(
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          name        TEXT NOT NULL,
          note        TEXT,
          status      INTEGER,
          created_at  TEXT NOT NULL,
          disable     BOOLEAN DEFAULT 0
      )

    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá
      await db.execute(""" CREATE TABLE order (
          id          INTEGER PRIMARY KEY AUTOINCREMENT,
          total       REAL NOT NULL,
          note        TEXT,
          payment_id  INTEGER,
          status      INTEGER, 
          created_at  TEXT NOT NULL,
          disable     BOOLEAN DEFAULT 0,
          FOREIGN KEY (payment_id) REFERENCES payment (id)
      )
    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá

    await db.execute(""" CREATE TABLE order_detail (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id    INTEGER,
          order_id      INTEGER,
          amount        INTEGER,
          created_at    TEXT NOT NULL,
          disable       BOOLEAN DEFAULT 0,
          FOREIGN KEY (product_id) REFERENCES products (id),
          FOREIGN KEY (order_id) REFERENCES orders (id)
      )
    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá 
    
    await db.execute(""" CREATE TABLE generic(
          id         INTEGER PRIMARY KEY AUTOINCREMENT,
          name       TEXT NOT NULL,
          value      TEXT,
          status     TEXT,
          created_at TEXT NOT NULL,
          disable    BOOLEAN DEFAULT 0
      )
    """);// Để xuống dòng được mà khôgng bị sai thì dùng cặp dấu này nhá
    }
  }
      
//https://www.youtube.com/watch?v=noi6aYsP7Go
// https://www.youtube.com/watch?v=xWt7dwcR1jo

// forgerin key 
// https://www.youtube.com/watch?v=lLqPIulkQYg