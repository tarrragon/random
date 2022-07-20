import 'dart:async';
import 'package:path/path.dart';
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
            "CREATE TABLE sportRecord(sport_record_sn Text, created_at TEXT,  heartbeat TEXT, vo2max TEXT)");
        await db.execute(
            "CREATE TABLE IF NOT EXISTS user(result INTEGER,errorMassage TEXT,username TEXT,key TEXT)");
        await db.execute(
            "CREATE TABLE IF NOT EXISTS meal(id INTEGER PRIMARY KEY,date NUMERIC,time NUMERIC,meal TEXT,cal REAL , amount REAL , food  TEXT , water REAL ,cafe REAL,alcohol REAL,  supply TEXT ,note)");
        await db.execute(
            "CREATE TABLE IF NOT EXISTS power(powerID INTEGER PRIMARY KEY AUTOINCREMENT,recordDate Text,recordTime TEXT,powerNumber INTEGER)");
        await db.execute(
            "CREATE TABLE IF NOT EXISTS alarm(alarmid INTEGER PRIMARY KEY AUTOINCREMENT,hour INTEGER,minute INTEGER,mon INTEGER,tues INTEGER,wed INTEGER,thur INTEGER,fri INTEGER,sat INTEGER,sun INTEGER,ringtone TEXT,repeat INTEGER)");
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
  
  
  


  Future insertHeartbeatData(HeartbeatModel model) async {
    final db = await database;
    return db.insert('sportRecord', model.toMap());
  }

  Future updateHeartbeat(HeartbeatModel model) async {
    final db = await database;
    return db
        .update('sportRecord', model.toMap(), where: "sport_record_sn = ?", whereArgs: [model.sport_record_sn]);
  }

  Future<int> deleteHeartbeat(String sport_record_sn) async {
    final db = await database;
    return db.delete('sportRecord', where: "sport_record_sn = ?", whereArgs: [sport_record_sn]);
  }

  Future<List<HeartbeatModel>> getHeartbeat() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sportRecord');
    List<HeartbeatModel> list = maps.isNotEmpty
        ? maps.map((note) => HeartbeatModel.fromMap(note)).toList()
        : [];

    return list;
  }

    Future<List<HeartbeatModel>> searchdata(String sport_record_sn) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sportRecord',  where: "sport_record_sn = ?", whereArgs: [sport_record_sn]);
    List<HeartbeatModel> list = maps.isNotEmpty
        ? maps.map((note) => HeartbeatModel.fromMap(note)).toList()
        : [];

    return list;
  }



  Future<HeartbeatModel> getHeartbeatNew() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sportRecord');
    List<HeartbeatModel> list = maps.isNotEmpty
        ? maps.map((note) => HeartbeatModel.fromMap(note)).toList()
        : [];

    return list.last;
  }


/////////////////////////
//
//   Future insertmealData(MealModel model) async {
//     final db = await database;
//     return db.insert('meal', model.toMap());
//   }
//
//   Future updatemeal(MealModel model) async {
//     final db = await database;
//     return db
//         .update('meal', model.toMap(), where: "id = ?", whereArgs: [model.id]);
//   }
//
//
//
//   Future<int> deletemeal(int id) async {
//     final db = await database;
//     return db.delete('meal', where: "id = ?", whereArgs: [id]);
//   }
//
//   Future<List<MealModel>> getmeal() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('meal');
//     List<MealModel> list = maps.isNotEmpty
//         ? maps.map((note) => MealModel.fromMap(note)).toList()
//         : [];
//
//     return list;
//   }
//
//   Future<List<MealModel>> getMealADay(MealModel model) async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('meal',  where: "date = ?", whereArgs: [model.date]);
//     List<MealModel> list = maps.isNotEmpty
//         ? maps.map((note) => MealModel.fromMap(note)).toList()
//         : [];
//
//     return list;
//   }


///////////////////





  Future insertPowerData(PowerModel model) async {
    final db = await database;
    return db.insert('power', model.toMap());
  }

  Future updatePowerNumber(PowerModel model) async {
    final db = await database;
    return db
        .update('power', model.toMap(), where: "powerID = ?", whereArgs: [model.powerID]);
  }

  Future<int> deletePowerData(String powerID) async {
    final db = await database;
    return db.delete('power', where: "powerID = ?", whereArgs: [powerID]);
  }

  Future<List<PowerModel>> getPowerData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('power');
    List<PowerModel> list = maps.isNotEmpty
        ? maps.map((note) => PowerModel.fromMap(note)).toList()
        : [];

    return list;
  }

  Future<List<PowerModel>> searchPowerData(String powerID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('power',  where: "powerID = ?", whereArgs: [powerID]);
    List<PowerModel> list = maps.isNotEmpty
        ? maps.map((note) => PowerModel.fromMap(note)).toList()
        : [];

    return list;
  }


//////////////////////////////////////////////////////////////////
//鬧鐘CRUD
//
//
//////////////////////////////////////////////////////////////////


  Future insertAlarm(AlarmDataModel model) async {
    print("alarm insert");
    final db = await database;
    return db.insert('alarm', model.toMap());
  }

  Future updateAlarm(AlarmDataModel model) async {
    final db = await database;
    return db
        .update('alarm', model.toMap(), where: "alarmid = ?", whereArgs: [model.alarmid]);
  }

  Future<int> deleteAlarm(int  alarmid) async {
    final db = await database;
    return db.delete('alarm', where: "alarmid = ?", whereArgs: [alarmid]);
  }

  Future<List<AlarmDataModel>> getAlarm() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('alarm');
    List<AlarmDataModel> list = maps.isNotEmpty
        ? maps.map((note) => AlarmDataModel.fromMap(note)).toList()
        : [];

    return list;
  }









  ///////////////////////////////////////////////////////////////////////////////////////////





  Future insertuserData(User model) async {
    await deleteuser();
    final db = await database;
    return db.insert('user', model.toMap());
  }
  Future updateuser(User model) async {



    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    if(maps.length > 0)
      return db
          .update('user', model.toMap(), where: "result = ?", whereArgs: [200]);
    else insertuserData(model);



    return db
        .update('user', model.toMap(), where: "id = ?", whereArgs: [1]);
  }


  Future<void> deleteuser() async {
    final db = await database;
     db.delete('user');
  }

  Future<User> getuser() async {

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');


    User user = maps.first as User;
    return user;
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