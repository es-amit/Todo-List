import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:to_do_list/model/todo.dart';

class DBHelper{
  static Database? _db;

  Future<Database?> get db async{
    // ignore: unnecessary_null_comparison
    if(_db != null){
      return _db!;
    }
    _db = await initDB();
    return null;
  }

    initDB() async{
      io.Directory  documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path,"Todo.db");
      var db = await openDatabase(
        path,
        version: 1,
        onCreate: _createDatabase 
      );
      return db;
    }

    _createDatabase(Database db,int version) async{
      await db.execute(
        "CREATE TABLE mytodo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, priority TEXT,category TEXT, status INTEGER)",
        
      );
    }

  // Inserting data
  Future<Todo> insert(Todo todo)async{
    var dbClient  = await db;
    await dbClient?.insert('mytodo',todo.toMap());
    return todo;
  }

  // Retrieving from the database
  Future<List<Todo>> getDataList() async{
    await db;
    // ignore: non_constant_identifier_names
    final List<Map<String, Object?>> QueryResult = await _db!.rawQuery('SELECT * FROM mytodo');
    return QueryResult.map((e) => Todo.fromMap(e)).toList();
  }

  // Deleting from database
  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('mytodo', where: 'id= ?', whereArgs: [id]);

  }

  Future<int> update(int id, Todo todo) async {
  try {
    print("Database wali id: $id");
    var dbClient = await db;
    int rows = await dbClient!.update(
      'mytodo',
      {
        'title': todo.title,
        'description': todo.description, // Add other fields as needed
        'priority': todo.taskPriority.name,
        'category': todo.category.name, // Example conversion, adjust based on your data type
        'status': todo.status ? 1 : 0, // Convert bool to int (0 or 1) if status is stored as an integer
        // Add other fields from Todo that need to be updated
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
      print("Rows updated: $rows");
      return rows;
  } catch (e) {
      print("Update error: $e");
      return 0;
  }
}



  
  Future<int> updateStatus(Todo todo, int id) async {
  var dbClient = await db;
  return await dbClient!.update(
    'mytodo',
    {'status': todo.status ? 1 : 0}, // Assuming status is a boolean in Todo, convert to 1 or 0
    where: 'id = ?',
    whereArgs: [id],
  );
}
}