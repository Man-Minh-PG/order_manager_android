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
    Future<bool> deleteOldDatabase() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      File dbFile = File(path);
      if (await dbFile.exists()) {
        await dbFile.delete();
        return true;
      }
      return false;
    }


  Future<String?> getDatabasePath() async {
  // Lấy đường dẫn thư mục lưu trữ cơ sở dữ liệu
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, _databaseName);
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
        createdAt TIMESTAMP NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')) 
      )
    ''');

    await db.execute('''
      CREATE TABLE payment(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        status INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        total INTEGER NOT NULL,
        discountDetail INTEGER DEFAULT 0,
        note TEXT,
        paymentId INTEGER,
        status INTEGER DEFAULT 0,
        isDiscount INTEGER DEFAULT 0,
        createdAt TIMESTAMP NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')) ,
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
        createdAt TIMESTAMP NOT NULL DEFAULT (strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')) ,
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
    insertProduct(db);
    insertPayment(db);
    insertGeneric(db);
    // Các lệnh insert khác ở đây...

  } // end function onCreate()


  /**
   * Function insert data default when load page
   */
  Future<void> insertProduct(Database db) async {
      await db.insert('product', {
        'name': 'Sieu_Pham',
        'description': 'PM-TR-C',
        'price': 30,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'PM_Chui',
        'description': 'PM-C',
        'price': 27,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });   

      await db.insert('product', {
        'name': 'PM_Trung',
        'description': 'PM-TR',
        'price': 27,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'PM_Bap',
        'description': 'PM-Bap',
        'price': 27,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Pho_Mai',
        'description': 'Pho Mai',
        'price': 24,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Tr_Chui',
        'description': 'TR + C',
        'price': 22,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Tr_Bap',
        'description': 'TR + Bap',
        'price': 22,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

       await db.insert('product', {
        'name': 'Dua',
        'description': 'D',
        'price': 22,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Chui',
        'description': 'C',
        'price': 20,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Trung',
        'description': 'TR',
        'price': 20,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Ca_Cao',
        'description': 'CC',
        'price': 17,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Pho_Mai_them',
        'description': 'Topping +',
        'price': 8,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

        await db.insert('product', {
        'name': 'Mon_Khac',
        'description': 'Topping +',
        'price': 3,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });
      
        await db.insert('product', {
        'name': 'Now',
        'description': 'Pre order',
        'price': 0,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

        await db.insert('product', {
        'name': 'Grab',
        'description': 'Pre order',
        'price': 0,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Go',
        'description': 'Pre order',
        'price': 0,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });

      await db.insert('product', {
        'name': 'Bee',
        'description': 'Pre order',
        'price': 0,
        'imagePath': 'assets/images/grocery_images/banana.png',
      });
    }


    /**
     * Function insert data default when load page
     */
    Future<void> insertPayment(Database db) async {
      await db.insert('payment', {
        'name': 'Tien_mat',
      });

      await db.insert('payment', {
        'name': 'Momo',
      });

      await db.insert('payment', {
        'name': 'Chuyen_Khoan',
      });
    }


    /**
    * Function insert data default when load page
    *   name TEXT NOT NULL,
    *   value TEXT,
    */
    Future<void> insertGeneric (Database db) async {
      await db.insert('generic', {
          'name' : 'totalProduct',
          'value' : '0'
      });
    }

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