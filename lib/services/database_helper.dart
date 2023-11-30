import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_tracer/models/UserModel.dart';
import 'package:tree_tracer/models/favourite_model.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/image_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/models/root_model.dart';

class TracerDatabaseHelper {
  static final TracerDatabaseHelper instance = TracerDatabaseHelper._init();
  static Database? _database;

  TracerDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String path = join(await getDatabasesPath(), 'tracer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tracer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageBlob BLOB,
        imagePath TEXT,
        local_name TEXT,
        scientific_name TEXT,
        description TEXT,
        summary TEXT,
        family TEXT,
        benifits TEXT,
        uses TEXT,
        favourite BOOLEAN
      )
    ''');

    await db.execute('''
      CREATE TABLE root (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE flower (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leaf (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE fruit (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        description TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');
  
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tree_image (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imageBlob BLOB,
        imagePath TEXT,
        name TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE favourite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracerId INTEGER,
        imagePath TEXT,
        FOREIGN KEY (tracerId) REFERENCES tracer (id)
      )
    ''');
  }

  Future<int> registerUser(UserModel userData) async {
    final db = await database;
    final userReturnData = await db.insert('user', userData.toMap());
    return userReturnData;
  }

  Future<List<UserModel>> getAllUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> userData = await db.query('user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password]
    );

    // if (userResult.isNotEmpty) {
    //   return UserModel.fromMap(userResult.first);
    // } else {
    //   return null;
    // }e

    return userData.length > 0;
  }


  Future<int> insertDBTracerData(TracerModel tracerData) async {
    final db = await database;
    final tracerReturnData = await db.insert('tracer', tracerData.toMap());
    return tracerReturnData;
  }

  Future<RootModel> insertDBRootData(RootModel rootData) async {
    final db = await database;
    final id = await db.insert('root', rootData.toMap());
    return rootData;
  }

  Future<FlowerModel> insertDBFlowerData(FlowerModel flowerData) async {
    final db = await database;
    final id = await db.insert('flower', flowerData.toMap());
    return flowerData;
  }

  Future<LeafModel> insertDBLeafData(LeafModel leafData) async {
    final db = await database;
    final id = await db.insert('leaf', leafData.toMap());
    return leafData;
  }

  Future<FruitModel> insertDBFruitData(FruitModel fruitData) async {
    final db = await database;
    final id = await db.insert('fruit', fruitData.toMap());
    return fruitData;
  }

  Future<List<TracerModel>> getTracerDataList() async {
    final db = await database;
    print('========= db ======= ${db}');
    final List<Map<String, dynamic>> maps = await db.query('tracer');
    return List.generate(maps.length, (i) {
      return TracerModel.fromMap(maps[i]);
    });
  }

  Future<List<TracerModel>> getTracerFavouriteDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tracer', where: 'favourite = ?', whereArgs: [1],);
    return List.generate(maps.length, (i) {
      return TracerModel.fromMap(maps[i]);
    });
  }

  Future<List<RootModel>> getRootDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('root');
    return List.generate(maps.length, (i) {
      return RootModel.fromMap(maps[i]);
    });
  }

  Future<List<FlowerModel>> getFlowerDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('flower');
    return List.generate(maps.length, (i) {
      return FlowerModel.fromMap(maps[i]);
    });
  }

  Future<List<LeafModel>> getLeafDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('leaf');
    return List.generate(maps.length, (i) {
      return LeafModel.fromMap(maps[i]);
    });
  }

  Future<List<FruitModel>> getFruitDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fruit');
    return List.generate(maps.length, (i) {
      return FruitModel.fromMap(maps[i]);
    });
  }

  Future<TracerModel?> getOneTracerData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('tracer',
      where: 'id = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return TracerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<TracerModel?> getTracerImages(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('favourite',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return TracerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

Future<RootModel?> getOneRootData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('root',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return RootModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<FlowerModel?> getOneFlowerData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('flower',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return FlowerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<LeafModel?> getOneLeafData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('leaf',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return LeafModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

    Future<FruitModel?> getOneFruitData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db.query('fruit',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return FruitModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<List<Map<String, dynamic>>?> getTracerAndData(int tracerId) async {
    final db = await database;

    // Query the tracer table based on the tracerId
    final tracerData = await db.query('tracer',
        where: 'id = ?',
        whereArgs: [tracerId]);

    // Query the Root table based on the tracerId
    final rootData = await db.query('root',
        where: 'tracerId = ?',
        whereArgs: [tracerId]);
    
    final flowerData = await db.query('flower',
        where: 'tracerId = ?',
        whereArgs: [tracerId]);

    final leafData = await db.query('leaf',
        where: 'tracerId = ?',
        whereArgs: [tracerId]);
  
    final fruitData = await db.query('fruit',
        where: 'tracerId = ?',
        whereArgs: [tracerId]);

    // Combine the tracer and Root data into a single list
    List<Map<String, dynamic>> combinedData = [];
    combinedData.add(tracerData.first);
    combinedData.addAll(rootData);
    combinedData.addAll(flowerData);
    combinedData.addAll(leafData);
    combinedData.addAll(fruitData);

    return combinedData;
  }

  Future<void> updateFavouriteStatus(int id, int isFavourite) async {
    final db = await database;
    await db.update(
      'tracer',
      {'favourite': isFavourite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTracerData(TracerModel tracerData) async {
    final db = await database;
    await db.update(
      'tracer',
      tracerData.toMap(),
      where: 'id = ?',
      whereArgs: [tracerData.id],
    );
  }

  Future<void> updateRootData(RootModel rootData) async {
    final db = await database;
    await db.update(
      'root',
      rootData.toMap(),
      where: 'id = ?',
      whereArgs: [rootData.id],
    );
  }

  Future<void> updateFlowerData(FlowerModel flowerData) async {
    final db = await database;
    await db.update(
      'flower',
      flowerData.toMap(),
      where: 'id = ?',
      whereArgs: [flowerData.id],
    );
  }

  Future<void> updateLeafData(LeafModel leafData) async {
    final db = await database;
    await db.update(
      'leaf',
      leafData.toMap(),
      where: 'id = ?',
      whereArgs: [leafData.id],
    );
  }

  Future<void> updateFruitData(FruitModel fruitData) async {
    final db = await database;
    await db.update(
      'fruit',
      fruitData.toMap(),
      where: 'id = ?',
      whereArgs: [fruitData.id],
    );
  }

  Future<void> deleteTracerData(int id) async {
    final db = await database;
    await db.delete(
      'tracer',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteRootData(int id) async {
    final db = await database;
    await db.delete(
      'root',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFlowerData(int id) async {
    final db = await database;
    await db.delete(
      'flower',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteLeafData(int id) async {
    final db = await database;
    await db.delete(
      'leaf',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFruitData(int id) async {
    final db = await database;
    await db.delete(
      'fruit',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Tree Image Query Services
  Future<ImageModel> insertDBTreeImageData(ImageModel imageData) async {
    final db = await database;
    final id = await db.insert('tree_image', imageData.toMap());
    return imageData;
  }

  Future<List<ImageModel>> getTreeImageDataList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tree_image');
    return List.generate(maps.length, (i) {
      return ImageModel.fromMap(maps[i]);
    });
  }

  Future<ImageModel?> getOneTreeImageData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> imageData = await db.query('tree_image',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (imageData.isNotEmpty) {
      return ImageModel.fromMap(imageData[0]);
    } else {
      return null;
    }
  }

  Future<void> updateTreeImageData(ImageModel imageData) async {
    final db = await database;
    await db.update(
      'tree_image',
      imageData.toMap(),
      where: 'id = ?',
      whereArgs: [imageData.id],
    );
  }

  Future<void> deleteTreeImageData(int id) async {
    final db = await database;
    await db.delete(
      'tree_image',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Favourite Query Services
  Future<FavouriteModel> insertDBFavouriteData(FavouriteModel imageData) async {
    final db = await database;
    final id = await db.insert('favourite', imageData.toMap());
    return imageData;
  }

  Future<List<FavouriteModel>> getFavouriteDataList(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favourite', where: 'tracerId = ?', whereArgs: [tracerId]);
    return List.generate(maps.length, (i) {
      return FavouriteModel.fromMap(maps[i]);
    });
  }

  Future<FavouriteModel?> getOneFavouriteData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> imageData = await db.query('favourite',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (imageData.isNotEmpty) {
      return FavouriteModel.fromMap(imageData[0]);
    } else {
      return null;
    }
  }

  Future<void> updateFavouriteData(FavouriteModel imageData) async {
    final db = await database;
    await db.update(
      'favourite',
      imageData.toMap(),
      where: 'id = ?',
      whereArgs: [imageData.id],
    );
  }

  Future<void> deleteFavouriteData(int id) async {
    final db = await database;
    await db.delete(
      'favourite',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<void> initiateUserData(TracerDatabaseHelper dbHelper) async {
    // TracerDatabaseHelper dbHelper = TracerDatabaseHelper.instance;
    final newUser = UserModel(username: 'admin', password: '123123123');
    final registeredUser = await dbHelper.registerUser(newUser);

  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<Uint8List> loadImageAsUint8List(path) async {
    // Load the image data from the asset
    final ByteData data = await rootBundle.load(path);

    // Convert the ByteData to a Uint8List
    Uint8List uint8List = data.buffer.asUint8List();

    return uint8List;
  }

  Future<void> initiateTracerData(TracerDatabaseHelper dbHelper) async {

    if(await getFlagFromTempStorage()) {
      print("already initialize");

    } else {
      await setFlagInTempStorage();

      List<dynamic> tree_datas = [
        {
          'path': 'assets/images/balobo.jpeg',
          'image_paths': [
            'assets/images/balobo.jpeg',
            'assets/images/balobo.jpeg',
            'assets/images/balobo.jpeg',
            'assets/images/balobo.jpeg'
          ],
          'local_name': 'Sample Local Name',
          'scientific_name': 'Sample Scientific Name',
          'description': 'Sample Description',
          'family': 'Sample Family',
          'benifits': 'Sample Benifits',
          'summary': '',
          'uses': ''
        },
        {
          'path': 'assets/images/alagau1.jpeg',
          'image_paths': [
            'assets/images/alagau1.jpeg',
            'assets/images/alagau2.jpeg',
            'assets/images/alagau3.jpeg',
            'assets/images/alagau4.jpeg',
            'assets/images/alagau5.jpeg',
          ],
          'local_name': 'Alagau',
          'scientific_name': 'Sample Scientific Name',
          'description': 'Sample Description',
          'family': 'Sample Family',
          'benifits': 'Sample Benifits',
          'summary': '',
          'uses': ''
        }

      ];

      for (var tracer in tree_datas) {
        final Uint8List tracerImageBytes = await loadImageAsUint8List(tracer['path']);

        // final Uint8List tracerImageBytes = await fileToUint8List(File(tracer['path']));

        var newTracer = TracerModel(
          imageBlob: tracerImageBytes, 
          imagePath: tracer['path'],
          local_name: tracer['local_name'], 
          scientific_name: tracer['scientific_name'], 
          description: tracer['description'], 
          summary: tracer['summary'],
          family: tracer['family'],
          benifits: tracer['benifits'],
          uses: tracer['uses'],
          favourite: 0
        );

        int newTreeId = await dbHelper.insertDBTracerData(newTracer);

        print("============newTreeId========");
        print(newTreeId);

        for (var tracerImgPath in tracer['image_paths']) {
          final fav = FavouriteModel(
            tracerId: newTreeId,
            imagePath: tracerImgPath
          );

          await dbHelper.insertDBFavouriteData(fav);
        }
      }
    }
  }

  Future<void> setFlagInTempStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_seed', true);
  }

  Future<bool> getFlagFromTempStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_seed') ?? false; // Use a default value if the flag is not set.
  }

  Future<void> updateFlagInTempStorage(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_seed', newValue);
  }

  Future<List<Map>> getImagesFromTracer() async {
    final db = await database;
    List<Map> tracerImages = await db.rawQuery('SELECT id, imageBlob, imagePath, local_name, scientific_name FROM tracer');

    return tracerImages;
  }
}
