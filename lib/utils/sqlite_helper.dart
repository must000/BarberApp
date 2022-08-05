import 'package:barber/data/sqlite_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'barberApp.db';
  final int version = 1;
  final String tableDatabase = 'tableBarber';
  final String columnId = 'id';
  final String columnEmail = 'email';

  SQLiteHelper() {
    initislDatabase();
  }

  Future<Null> initislDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnEmail TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Database database = await connectedDatabase();
    List<SQLiteModel> results = [];
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    print('### maps on SQLitHelper ==>> $maps');
    for (var item in maps) {
      SQLiteModel model = SQLiteModel.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<Null> insertValueToSQlite(SQLiteModel sqLiteModel) async {
    Database database = await connectedDatabase();
    await database.insert(tableDatabase, sqLiteModel.toMap()).then(
        (value) => print('### insert Value name ==>>${sqLiteModel.email}'));
  }

//ลบไอดีที่เลือก
  Future<void> deleteSQLiteWhereId(int id) async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase, where: '$columnId = $id')
        .then((value) => print('### Success Delete id ==> $id'));
  }

//ลบทั้งหมด
  Future<void> emptySQLite() async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase)
        .then((value) => print('### Delete empty succeed'));
  }
}
