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

class MangroveDatabaseHelper {
  static final MangroveDatabaseHelper instance = MangroveDatabaseHelper._init();
  static Database? _database;

  MangroveDatabaseHelper._init();

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


  Future<int> insertDBMangroveData(TracerModel mangrooveData) async {
    final db = await database;
    final mangrooveReturnData = await db.insert('tracer', mangrooveData.toMap());
    return mangrooveReturnData;
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
    final List<Map<String, dynamic>> mangroveData = await db.query('tracer',
      where: 'id = ?',
      whereArgs: [tracerId]);

    if (mangroveData.isNotEmpty) {
      return TracerModel.fromMap(mangroveData[0]);
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
    final List<Map<String, dynamic>> mangroveData = await db.query('root',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (mangroveData.isNotEmpty) {
      return RootModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<FlowerModel?> getOneFlowerData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('flower',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (mangroveData.isNotEmpty) {
      return FlowerModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<LeafModel?> getOneLeafData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('leaf',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (mangroveData.isNotEmpty) {
      return LeafModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

    Future<FruitModel?> getOneFruitData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> mangroveData = await db.query('fruit',
      where: 'tracerId = ?',
      whereArgs: [tracerId]);

    if (mangroveData.isNotEmpty) {
      return FruitModel.fromMap(mangroveData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<List<Map<String, dynamic>>?> getMangroveAndData(int tracerId) async {
    final db = await database;

    // Query the tracer table based on the tracerId
    final mangroveData = await db.query('tracer',
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
    combinedData.add(mangroveData.first);
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

  Future<void> updateTracerData(TracerModel mangrooveData) async {
    final db = await database;
    await db.update(
      'tracer',
      mangrooveData.toMap(),
      where: 'id = ?',
      whereArgs: [mangrooveData.id],
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

  Future<void> deleteFavouriteeData(int id) async {
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

  Future<void> initiateUserData(MangroveDatabaseHelper dbHelper) async {
    // MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
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

  Future<void> initiateMangrooveData(MangroveDatabaseHelper dbHelper) async {

    if(await getFlagFromTempStorage()) {
      print("already initialize");

    } else {
      await setFlagInTempStorage();

      List<dynamic> mangrove_datas = [
        {
          'path': 'assets/images/balobo.jpeg',
          'image_paths': [
            'assets/images/balobo.jpeg',
            'assets/images/balobo.jpeg',
            'assets/images/balobo.jpeg'
          ],
          'local_name': 'Sample Local Name',
          'scientific_name': 'Sample Scientific Name',
          'description': 'Sample Description',
          'summary': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras in felis vitae purus dignissim malesuada vel vitae ex. Mauris at purus ac urna dapibus hendrerit. Suspendisse tristique diam porta, mattis odio id, bibendum erat. Aliquam molestie metus aliquet ipsum condimentum, in fermentum leo varius. Suspendisse ante ante, tempus nec diam quis, aliquet ornare libero. Suspendisse finibus lectus enim, vel lobortis neque egestas nec. Phasellus semper mauris vel efficitur sollicitudin. In tempor justo id sapien hendrerit, et tincidunt enim condimentum. In volutpat nisl in ipsum malesuada suscipit. Duis magna lacus, fringilla malesuada nisi sit amet, lacinia pharetra diam. Maecenas mollis a nibh bibendum pellentesque.',
          'family': 'Sample Family',
          'benifits': 'Sample Benifits',
          'uses': 'Sample Uses',
          'root': {
            'path': 'assets/images/balobo.jpeg',
            'name': 'Root',
            'description': 'Sample Description'
          },
          'flower': {
            'path': 'assets/images/balobo.jpeg',
            'name': 'Flower',
            'description': 'Sample Description'
          },
          'leaf': {
            'path': 'assets/images/balobo.jpeg',
            'name': 'Leaf',
            'description': 'Sample Description'
          },
          'fruit': {
            'path': 'assets/images/balobo.jpeg',
            'name': 'Fruit',
            'description': 'Sample Description'
          },
        }
      
      ];

      for (var tracer in mangrove_datas) {
        final Uint8List tracerImageBytes = await loadImageAsUint8List(tracer['path']);
        final Uint8List fruitImageBytes = await loadImageAsUint8List(tracer['path']);
        final Uint8List rootImageBytes = await loadImageAsUint8List(tracer['path']);
        final Uint8List leafImageBytes = await loadImageAsUint8List(tracer['path']);
        final Uint8List flowerImageBytes = await loadImageAsUint8List(tracer['path']);

        // final Uint8List tracerImageBytes = await fileToUint8List(File(tracer['path']));

        var newMangroove = TracerModel(
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

        int newMangrooveId = await dbHelper.insertDBMangroveData(newMangroove);

        print("============newMangrooveId========");
        print(newMangrooveId);

        for (var tracerImgPath in tracer['image_paths']) {
          final fav = FavouriteModel(
            tracerId: newMangrooveId,
            imagePath: tracerImgPath
          );

          await dbHelper.insertDBFavouriteData(fav);
        }


        final newRoot = RootModel(
          tracerId: newMangrooveId ?? 0,
          imageBlob: rootImageBytes, 
          imagePath: tracer['path'],
          name: tracer['root']['name'],
          description: tracer['root']['description'],
        );

        final newFlower = FlowerModel(
          tracerId: newMangrooveId ?? 0,
          imageBlob: flowerImageBytes, 
          imagePath: tracer['path'],
          name: tracer['flower']['name'],
          description: tracer['flower']['description']
        );

        final newLeaf = LeafModel(
          tracerId: newMangrooveId ?? 0,
          imageBlob: leafImageBytes, 
          imagePath: tracer['path'],
          name: tracer['leaf']['name'],
          description: tracer['leaf']['description']
        );

        final newFruit = FruitModel(
          tracerId: newMangrooveId ?? 0,
          imageBlob:  fruitImageBytes, 
          imagePath: tracer['path'],
          name: tracer['fruit']['name'],
          description: tracer['fruit']['description']
        );

        final root_id = dbHelper.insertDBRootData(newRoot);
        final flower_id = dbHelper.insertDBFlowerData(newFlower);
        final leaf_id = dbHelper.insertDBLeafData(newLeaf);
        final fruit_id = dbHelper.insertDBFruitData(newFruit);
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

  Future<List<Map>> getImagesFromMangrove() async {
    final db = await database;
    List<Map> mangroveImages = await db.rawQuery('SELECT id, imageBlob, imagePath, local_name, scientific_name FROM tracer');

    return mangroveImages;
  }
}
