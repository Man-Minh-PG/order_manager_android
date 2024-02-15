import 'dart:io' ;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository { 
  DatabaseRepository.privateConstructor();

  static final DatabaseRepository instance =
    DatabaseRepository.privateConstructor();
  
  static Database? _database;
  final _databaseName    = 'bachutha';
  final _databaseVersion = 1;  


  // Hàm xóa cơ sở dữ liệu cũ
    Future<void> deleteOldDatabase() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      File dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
    }


  Future<String?> getDatabasePath() async {
  // Lấy đường dẫn thư mục lưu trữ cơ sở dữ liệu
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'your_database_name.db');
    print(databasePath) ;
}



  Future<Database?> get database async { // function check isset db
  // deleteOldDatabase();
  if (_database != null) {
    return _database;
  } else {
      // getDatabasePath();
    _database = await _initDatabase();
    return _database;
  }
}

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: onCreate);
  }

  // Create Database
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price INTEGER NOT NULL,
        imagePath TEXT,
        orderQuantity INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        note TEXT,
        status INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        total INTEGER NOT NULL,
        note TEXT,
        paymentId INTEGER,
        status INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (paymentId) REFERENCES payment (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE order_detail (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        productId INTEGER,
        orderId INTEGER,
        amount INTEGER,
        status INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (productId) REFERENCES product (id),
        FOREIGN KEY (orderId) REFERENCES orders (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE generic(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        value TEXT,
        status INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Sample product data
    // await db.insert('product', {
    //   'name': 'Sieu Pham',
    //   'price': 30,
    //   'imagePath': 'assets/images/grocery_images/banana.png',
    // });

    // Các lệnh insert khác ở đây...

  } // end function onCreate()

  // Create function insert - update - delete
     Future<int> insert(String table, Map<String, dynamic> values) async {
      return await _database?.insert(table, values) ?? 0;
    }

    Future<List<Map<String, dynamic>>> query(String table) async {
      return await _database?.query(table) ?? [];
    }

    Future<int> update(String table, Map<String, dynamic> values,
        {String? where, List<Object?>? whereArgs}) async {
      return await _database?.update(table, values, where: where, whereArgs: whereArgs) ?? 0;
    }

    Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) async {
      return await _database?.delete(table, where: where, whereArgs: whereArgs) ?? 0;
    }

  }
      
//https://www.youtube.com/watch?v=noi6aYsP7Go
// https://www.youtube.com/watch?v=xWt7dwcR1jo

// forgerin key 
// https://www.youtube.com/watch?v=lLqPIulkQYg