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
        },
        {
          'path': 'assets/images/alagau1.jpeg',
          'image_paths': [
            'assets/images/alagau2.jpeg',
            'assets/images/alagau3.jpeg',
            'assets/images/alagau4.jpeg',
            'assets/images/alagau5.jpeg',
          ],
          'local_name': 'Alagau',
          'scientific_name': 'Premna odorata',
          'description': 'Alagau is a tropical tree species found in various parts of Southeast Asia, including the Philippines. It is known for its fragrant leaves and is commonly used
in traditional herbal medicine and aromatherapy. Alagau is a medium-sized tree that can grow up to 12 meters (about 39 feet) tall. It has simple, opposite leaves with a strong and pleasant aroma when crushed. The leaves of the Alagau tree are elliptical, glossy, and dark green. They are often used for their aromatic qualities.',
          'family': 'Verbenaceae',
          'benifits': 'The leaves of Alagau emit a distinct, sweet, and somewhat citrusy fragrance when crushed. This aroma is often used in herbal preparations and is believed to have medicinal properties.
In traditional medicine, various parts of the Alagau tree are used to make remedies for various ailments, including coughs, colds, and fevers. The leaves are also used for their calming and soothing aroma in aromatherapy.
Habitat: Alagau trees are typically found in lowland and montane forests in the Philippines and other parts of Southeast Asia.',
        },
        {
          'path': 'assets/images/alakaakpula1.jpeg',
          'image_paths': [
            'assets/images/alakaakpula2.jpeg',
            'assets/images/alakaakpula3.jpeg',
            'assets/images/alakaakpula4.jpeg',
            'assets/images/alakaakpula5.jpeg',
          ],
          'local_name': 'Alakaak Pula',
          'scientific_name': 'Palaqium aureum Elm. Ex Merr',
          'description': 'Palaquium aureum is a hardwood tree that can reach heights of up to 25 meters. It is known for its valuable timber, which is used in various applications,
including construction, furniture making, and boat building. The wood has a reddish-brown to dark brown color and is prized for its durability and resistance to decay.
This tree species is found in various regions of the Philippines, particularly in lowland and mountain forests.',
          'Conservation Status': 'The conservation status of Palaquium aureum may vary, but like many native tree species in the Philippines, it may face conservation challenges due to deforestation and habitat loss.',
          'family': 'Sapotaceae',
          'uses': 'The timber of Palaquium aureum is highly valued in the Philippines for its strength and resistance to termites. It is commonly used in traditional house construction, furniture, and other woodworking applications.'
        },
        {
          'path': 'assets/images/apitong1.jpeg',
          'image_paths': [
            'assets/images/apitong2.jpeg',
            'assets/images/apitong3.jpeg',
          ],
          'local_name': 'Apitong',
          'scientific_name': 'Dipterocarpus grandiflorus Blanco',
          'description': 'The Apitong tree, also known as the Philippine Mahogany, is one of the most sought-after trees in the timber industry. With its remarkable strength and durability,
this forest giant has been used for various applications ranging from heavy-duty vehicle flooring to high-end furniture. But what makes it so expensive? Is planting Apitong profitable? And what are some of the alternatives available? In this blog post, we’ll take a closer look at everything you need to know about this magnificent hardwood tree – from its description and characteristics to its conservation status and more.',
          'family': 'Dipterocarpaceae',
          'benifits': 'Effective against rheumatism and liver diseases',
        },
        {
          'path': 'assets/images/BagwakMorado1.jpeg',
          'image_paths': [
            'assets/images/bagwakmorado2.jpeg',
            'assets/images/bagwakmorado3.jpeg',
            'assets/images/bagwakmorado4.jpeg',
            'assets/images/bagwakmorado5.jpeg',
          ],
          'local_name': 'Bagawak Morado',
          'scientific_name': 'Cierodendron pubescens',
          'description': 'Bagawak Morado" is one of the common names for this tree in the Philippines. The name "Morado" refers to its purplish flowers.
Clerodendrum pubescens is a medium-sized to large tree that can grow up to 25 meters (about 82 feet) in height. The leaves are typically simple, opposite, and have a somewhat rough or pubescent (hairy) texture, which is reflected in its scientific name. The tree produces clusters of small, tubular, and fragrant flowers. These flowers are often purplish in color and attract pollinators like butterflies and bees.After flowering, Clerodendrum pubescens produces small, fleshy, and often dark-colored fruits.',
          'family': 'Verbenaceae',
          'uses': 'Bagawak Morado (Clerodendrum pubescens) is known to have various traditional medicinal uses in the Philippines and other regions where it is found.
Feer Reduction: The leaves of Bagawak Morado are sometimes used to prepare herbal remedies for reducing fever. They may be brewed into a tea or decoction and consumed for their potential antipyretic (fever-reducing) properties.
Pain Relief: In traditional medicine, parts of the tree, including the leaves and bark, may be used to alleviate pain, such as headaches and body aches.
Anti-Inflammatory: Some preparations made from Bagawak Morado are believed to have anti-inflammatory properties and may be used to treat inflammatory conditions.
Antioxidant: The plant may contain compounds with antioxidant properties, which could help protect cells from oxidative stress and related health issues.
Digestive Ailments: In some traditional remedies, Bagawak Morado may be used to address digestive problems, such as indigestion or stomach discomfort.
Wound Healing: Extracts or poultices made from various parts of the tree are sometimes applied topically to wounds or skin irritations to promote healing.',
        },
        {
          'path': 'assets/images/bakan1.jpeg',
          'image_paths': [
            'assets/images/bakan2.jpeg',
            'assets/images/Bakan3.jpeg',
          ],
          'local_name': 'Bakan',
          'scientific_name': 'Litsea philippinensis Merr',
          'description': 'Bakan is a tree native to the Philippines prized for its oil-rich seeds used in traditional hair care, massage, and soap production, as well as for its potential 
in traditional medicine, , cultural importance, and applications in cosmetics and industry, while also benefiting local biodiversity.',
          'family': 'Lauraceae',
          'benifits': 'The benefits of the Bakan tree include its oil-rich seeds used in traditional hair care and soap making, its potential in traditional medicine, cultural significance, applications in cosmetics and industry, and its role in supporting local biodiversity.',
        },
        {
          'path': 'assets/images/batikuling1.jpeg',
          'image_paths': [
            'assets/images/batikuling2.jpeg',
            'assets/images/batikuling4.jpeg',
            'assets/images/batiukuling3.jpeg',
          ],
          'local_name': 'Batikuling',
          'scientific_name': 'Litsea leytensis Merr',
          'description': 'Batikuling is a large tree widely found in the forests of Luzon, especially in Quezon Province. 
The batikuling wood is hard, pale in color and, at one time, was used for making agricultural tools handles and laundry paddles.',
          'family': 'Lauraceae',
          'benifits': 'batikuling for woodcarving creates a continuing demand, which allows illegal loggers to thrive in business, as admitted by several people from Paete. In fact, illegal logging is the only way to acquire the batikuling in Paete, with carabao loggers or small-scale poachers coming all the way from Quezon Province. Other than this region, batikuling can also be found in Bataan, Sorsogon, Negros, and Leyte, but woodcarvers from Paete source their wood from nearby sources'
        },
        {
          'path': 'assets/images/batino1.jpeg',
          'image_paths': [
            'assets/images/batino2.jpeg',
            'assets/images/batino3.jpeg',
          ],
          'local_name': 'Batino',
          'scientific_name': 'Alstonia macrophylla Wall. Ex DC',
          'description': 'Batino tree is a medium-sized tree, growing up to 20 meters high. Bark is smooth. Branches are 4-angled. 
Leaves are in whorls of three, oblong-obovate, 10 to 30 centimeters long, 5 to 7 centimeters wide, and short-stalked.',
          'family': 'Apocynaceae',
          'benifits': 'Batino is used as febrifuge, tonic, antiperiodic, antidysenteric, emmenagogue, anticholeric, and vulnerary.',
        },
        {
          'path': 'assets/images/dolalog.jpeg',
          'image_paths': [
            'assets/images/dolalog1.jpeg',
            'assets/images/dolalog2.jpeg',
            'assets/images/dolalog3.jpeg',
          ],
          'local_name': 'Dolalog',
          'scientific_name': 'Ficus variegata var. sycomoroides',
          'description': 'Dolalog is a well distributed species of tropical fig tree. It occurs in many parts of Asia, islands of the Pacific and as far south east as Australia. 
There is a large variety of local common names including common red stem fig, green fruited fig and variegated fig.
Ficus variegata is a species of fig tree found throughout Southeast Asia, often growing on forested floodplains or town’s edges. Also known as the variegated fig or red-stem fig, it is a fast-growing tree that reaches 7 to 37 m (23 to 120 ft) high. Its leaves are large and heart-shaped. The tree is easily recognized by its cauliflory, meaning that fruit grows directly out of its trunk. These edible, red-brown figs are about a half inch in diameter. As the species is dioecious, there are male and female trees. Specialized fig wasps carry out pollination by breeding inside the figs, part of a mutually beneficial relationship, and the trees flower asynchronously to support the wasps throughout the year. Ficus variegata interacts with many other animals; its fruit is eaten and seeds dispersed by as many as 41 species, including fruit bats, orangutans, gibbons, wild pigs, and deer. The tree also produces a kind of wax used in the art of batik, a method of resist-dyeing to create patterned textiles.',
          'family': 'Moraceae',
          'benifits': 'According to Burkill, the fibrous bark is used by jungle natives to make a felt-like cloth used for loin cloths. The sweet bark is chewed or the fruits used instead, to cure dysentery.In the past the latex was used in the batik industry. The fruits are apparently only eaten in times of famine and Burkill said that "no European could stomach them".',
        },
        {
          'path': 'assets/images/isis.jpeg',
          'image_paths': [
            'assets/images/isis1.jpeg',
            'assets/images/isis2.jpeg',
          ],
          'local_name': 'Is-is',
          'scientific_name': 'Ficus ulmifolia',
          'description': 'Is-is is a shrub or small tree, 3-5 m tall. Leaves are alternate,variable in shape, subentire, undulately lobed or coarsely toothed, 
sometimes deeply or narrowly lobed, base rounded and three nerved, 9-17 cm by 4-8 cm. Fruit is a fig, subglobose, about 1.5 cm long, orange-red to purple, axillary, solitary or in pairs, edible. ',
          'family': 'Moraceae',
          'benifits': 'Fruits are edible, although with little flavor, sometimes eaten with sugar and cream.
Leaves used in the treatment of allergy, asthma, diarrhea, diabetes, tumor and cancer.
Others
- Scouring: Young leaves are used to clean cooking utensils and to scour wood floors, stairs, etc.
- Broiler supplement: Study showed applicability and benefits for use of the fruit as supplements to commercial mash, which resulted in significant weight gain and better animal performance. (4)
- Repellent: Ayta people of Pampanga burn leaves and stem as mosquito repellent. (6)
- Wood: Used for crafts and furniture making',
        },
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
