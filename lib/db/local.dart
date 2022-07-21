import 'dart:async';
import 'package:path/path.dart';
import 'package:random/models/dataModel.dart';
import 'package:sqflite/sqflite.dart';



class AppDB {
  static final AppDB db = AppDB();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await openDb();
    return _database!;
  }

  Future openDb() async {
    // 獲取我們的應用程序目錄的位置。這是我們應用程序文件的存儲位置，並且僅存儲我們的應用程序文件。
    // 當應用被刪除時，此目錄中的文件也會被刪除。
    return await openDatabase(join(await getDatabasesPath(), 'qi.db'),
      version: 1,
      onOpen: (db) async {}, onCreate: (Database db, int version) async {

        await db.execute(
            "CREATE TABLE record(dataId Text, day INTEGER,  year INTEGER, month INTEGER,content TEXT ,answer TEXT)");
         await db.execute(
            "CREATE TABLE IF NOT EXISTS setting(id INTEGER PRIMARY KEY AUTOINCREMENT,key TEXT,value TEXT)");

      },

    );
  }
  Future insertSetting(key,value) async {
    final db = await database;
    Map<String, dynamic> row = {
      "key" : key,
      "value"  : value
    };


    return db.insert('setting', row);
  }

  Future updateSetting(key,value) async {
    final db = await database;
    Map<String, dynamic> row = {
      "key" : key,
      "value"  : value
    };
    return db
        .update('setting', row, where: "key = ?", whereArgs: [key]);
  }

  Future<List<Map<String, dynamic>>> getSetting(key) async {
    final db = await database;
    // return db.query('setting' );
    return db.rawQuery('SELECT value FROM setting WHERE  key = ?',  [key]);

  }
  
  
  


  Future insertData(DataModel model) async {
    final db = await database;

    return db.insert('record', model.toMap());
  }

  Future updateData(DataModel model) async {
    final db = await database;
    return db
        .update('record', model.toMap(), where: "dataId = ?", whereArgs: [model.dataId]);
  }

  Future<int> deleteData(int dataId) async {
    final db = await database;
    return db.delete('record', where: "dataId = ?", whereArgs: [dataId]);
  }

  Future<List<DataModel>> getData() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('record', where: "day=? and month=?", whereArgs: [DateTime.now().day,DateTime.now().month]);
    List<DataModel> list = maps.isNotEmpty
        ? maps.map((note) => DataModel.fromMap(note)).toList()
        : [];

    return list;
  }

    Future<List<DataModel>> searchData(int dataId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sportRecord',  where: "sport_record_sn = ?", whereArgs: [dataId]);
    List<DataModel> list = maps.isNotEmpty
        ? maps.map((note) => DataModel.fromMap(note)).toList()
        : [];

    return list;
  }



///////////

  Future close() async => db.close();



}

/////////////////////crud範本//////////////////



// Future insert(Message msg) async {
//   final db = await _initDB();
//
//   await db.insert(
//     'chat',
//     msg.toJson(),
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }
//
// Future<List<Message>> query() async {
//   final db = await _initDB();
//   final List<Map<String, dynamic>> maps =
//   await db.rawQuery('SELECT * FROM chat ORDER BY time DESC LIMIT 30;');
//
//   var data = List.generate(maps.length, (i) {
//     return Message.fromJson(maps[i]);
//   });
//
//   return List.from(data.reversed);
// }
//
//
// Future<int> delete(String mid) async {
//   final db = await _initDB();
//   return await db.rawDelete('DELETE FROM chat WHERE mid = ?', [mid]);
// }
//
//
//
// Future<void> close() async {
//   final db = await _initDB();
//   await db.close();
// }


///////////////////////////////////////







//
// class Qi {
//    late int id ;
//    late String account ;
//    late String name ;
//    late String password ;
//    late int isMember; //未註冊 0 已註冊 1 訂閱中 2
//    Qi({this.id =0, this.account ="", this.name ="", this.password = "", this.isMember = 0});
//
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'account':account,
//       'name': name,
//       'password':password,
//       'isMember': isMember,
//     };
//   }
//
//
//
// }
//
//
//
//
// class QiDB {
//   static Database? _database;
//   Future<Database> get database async =>
//       _database = await _initDatabase();
//
//
//   static Future<Database> getDBConnect() async {
//
//
//
//     return await _initDatabase();
//   }
//
//
//
//
//   static Future<Database> _initDatabase() async {
//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'user.db'),
//
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE User(id TEXT PRIMARY KEY, name TEXT, isCompleted INTEGER)",
//         );
//       },
//       version: 1,
//
//     );
//     return _initDatabase();
//   }
//
//   static Future<List<Qi>> getUser() async {
//     final Database db = await getDBConnect();
//     final List<Map<String, dynamic>> maps = await db.query('user');
//     return List.generate(maps.length, (i) {
//       return Qi(
//         id: maps[i]['id'],
//         account: maps[i]['account'],
//         name: maps[i]['name'],
//         password: maps[i]['password'],
//         isMember: maps[i]['isMember'],
//
//
//       );
//     });
//   }
//
//   static Future<void> updateUser(Qi user) async {
//     final Database db = await getDBConnect();
//     await db.update(
//       'user',
//       user.toMap(),
//       where: "id = ?",
//       whereArgs: [user.id],
//     );
//   }
//
//   static Future<void> deleteTodo(String id) async {
//     final Database db = await getDBConnect();
//     await db.delete(
//       'user',
//       where: "id = ?",
//       whereArgs: [id],
//     );
//   }
//
//
//
//
// }