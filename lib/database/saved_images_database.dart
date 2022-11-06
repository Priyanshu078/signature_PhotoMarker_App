import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SavedImagesDatabase{
  late Database _database;

  Database get database => _database;

  Future openMyDatabase() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'imagesPath.db');
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE imagesPathTable (id INTEGER PRIMARY KEY autoincrement, path TEXT)');
        });
    print("database opened");
  }

  Future<List> getImagesPath() async {
    List<dynamic> images = await _database.rawQuery("SELECT path FROM imagesPathTable");
    return images;
  }

  Future<int> saveImagePath(String path) async{
    int index = await _database.insert('imagesPathTable',{"path" : path});
    return index;
  }

}