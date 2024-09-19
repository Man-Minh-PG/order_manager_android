import 'package:grocery_app/helpers/database.dart';
import 'package:sqflite/sqflite.dart'; 

class AppCommonService {
  final DatabaseRepository _databaseRepository = DatabaseRepository.instance;

  /**
   * Common funtion insert DB
   */
  Future<int> insertData(String tableName, Map<String ,dynamic> valueInsert) async {
    final db = await _databaseRepository.database;

    if (db == null) {
      // Xử lý khi db là null, ví dụ: thông báo lỗi hoặc kết thúc hàm
      print('Error: Database is null');
      return -1; // Trả về false để chỉ ra rằng insert thất bại
    }

    try {
      int idReult = await db.insert(
        tableName, 
        valueInsert,
        conflictAlgorithm:  ConflictAlgorithm.replace, // Chọn cách giải quyết xung đột nếu dữ liệu tồn tại
      );

      return idReult; // Trả về ID của dòng đã chèn thành công
    } catch(e) {
      print('Error inserting data: $e');
      return -1;
    }   
  }

  /**
   * Duplication funcion !
   * Common get/select data with table name
   * 
   * Example call function:
   *
   * Call with conditions
   * Map<String, dynamic> conditions = {
      'orders.id': 1,
      'order_detail.someColumn': 'someValue',
      };

      totalProduct = await orderService.getDataWithCondition('generic', conditions: conditions);

      Call without conditions
      totalProduct = await orderService.getDataWithCondition('generic');

   *   
   *  doc: /c/20d554d3-6893-48ad-a10b-6118630d7365
   */
  // Future<List<Map<String, dynamic>>> commonGetDataInTable(String tableName, {Map<String, dynamic> conditions = const {}}) async {
  Future<List<Map<String, dynamic>>> getDataWithCondition(String tableName, {Map<String, dynamic>? conditions} ) async { 
    final db = await _databaseRepository.database;

    List<String> whereClauses = [];
    List<dynamic> args = [];

    String query = '''
      SELECT *
      FROM $tableName
      ''';

    // Add the WHERE clause only if idOrder is provided
    if(conditions != null) {
        conditions.forEach((key, value) {
          whereClauses.add('$key = ?');
          args.add(value);  
        });

        if(whereClauses.isNotEmpty) {
          query += ' WHERE ' + whereClauses.join(' AND ');
        }
    }

    return await db!.rawQuery(query, args);
  }

  /**
   * Common update db
   * 
   */
  Future<int> updateData(
    String tableName, 
    Map<String, dynamic> valueUpdate, 
    {Map<String, dynamic>? conditions}) async {

    final db = await _databaseRepository.database;
    int resultUpdate = 0;

    try {
      // Xây dựng câu điều kiện WHERE
      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (conditions != null && conditions.isNotEmpty) {
        whereClause = conditions.keys.map((key) => '$key = ?').join(' AND ');
        whereArgs = conditions.values.toList();
      }

      // Thực hiện cập nhật dữ liệu
      resultUpdate = await db!.update(
        tableName, 
        valueUpdate,
        where: whereClause,
        whereArgs: whereArgs,
      );
    } catch (e) {
      print('Error while updating data: $e');
    }

    return resultUpdate;
  }

  /**
   * Get return single
   */
  int convertReturnSingle(List<Map<String, dynamic>>? item, String columnName)  {
    if(item == null){
      return 0;
    }

    return int.parse(item[0][columnName]);
  } 
}