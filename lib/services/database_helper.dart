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
        whereArgs: [username, password]);

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
    final List<Map<String, dynamic>> maps = await db.query(
      'tracer',
      where: 'favourite = ?',
      whereArgs: [1],
    );
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
    final List<Map<String, dynamic>> tracerData =
        await db.query('tracer', where: 'id = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return TracerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<TracerModel?> getTracerImages(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData = await db
        .query('favourite', where: 'tracerId = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return TracerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<RootModel?> getOneRootData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData =
        await db.query('root', where: 'tracerId = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return RootModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<FlowerModel?> getOneFlowerData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData =
        await db.query('flower', where: 'tracerId = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return FlowerModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<LeafModel?> getOneLeafData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData =
        await db.query('leaf', where: 'tracerId = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return LeafModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<FruitModel?> getOneFruitData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> tracerData =
        await db.query('fruit', where: 'tracerId = ?', whereArgs: [tracerId]);

    if (tracerData.isNotEmpty) {
      return FruitModel.fromMap(tracerData[0]);
    } else {
      return null; // Return null if no data is found for the given tracerId
    }
  }

  Future<List<Map<String, dynamic>>?> getTracerAndData(int tracerId) async {
    final db = await database;

    // Query the tracer table based on the tracerId
    final tracerData =
        await db.query('tracer', where: 'id = ?', whereArgs: [tracerId]);

    // Query the Root table based on the tracerId
    final rootData =
        await db.query('root', where: 'tracerId = ?', whereArgs: [tracerId]);

    final flowerData =
        await db.query('flower', where: 'tracerId = ?', whereArgs: [tracerId]);

    final leafData =
        await db.query('leaf', where: 'tracerId = ?', whereArgs: [tracerId]);

    final fruitData =
        await db.query('fruit', where: 'tracerId = ?', whereArgs: [tracerId]);

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
    final List<Map<String, dynamic>> imageData = await db
        .query('tree_image', where: 'tracerId = ?', whereArgs: [tracerId]);

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
    final List<Map<String, dynamic>> maps = await db
        .query('favourite', where: 'tracerId = ?', whereArgs: [tracerId]);
    return List.generate(maps.length, (i) {
      return FavouriteModel.fromMap(maps[i]);
    });
  }

  Future<FavouriteModel?> getOneFavouriteData(int tracerId) async {
    final db = await database;
    final List<Map<String, dynamic>> imageData = await db
        .query('favourite', where: 'tracerId = ?', whereArgs: [tracerId]);

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
    final newUser = UserModel(username: 'treetracer2023', password: '88888888');
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
    if (await getFlagFromTempStorage()) {
      print("already initialize");
    } else {
      await setFlagInTempStorage();

      List<dynamic> tree_datas = [
        {
          'path': 'assets/images/agoho1.jpg',
          'image_paths': [
            'assets/images/agoho1.jpg',
            'assets/images/agoho2.png',
            'assets/images/agoho3.jpg',
          ],
          'local_name': 'Agoho',
          'scientific_name': 'Casuarina rumphiana',
          'description':
              'Agoho is a large, evergreen tree, tall and straight, up to 20 meters high. Crown is narrowly pyramidal, resembling some of the conifers in appearance. Bark is brown and rough. Branchlets are very slender, about 20 centimeters long, mostly deciduous, composed of many joints. Internodes are about 1 centimeter long, somewhat 6- or 8-angled. Flowers are unisexual. Staminate spikes are slender, 1 to 3 centimeters long. Cones are usually ellipsoid, 1 to 2 centimeters long, composed of about 12 rows of achenes enclosed in the hardened bracts.',
          'family': 'Casuarinaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'Resembles a pine tree in appearance.- Considered antidiarrheal, anticancer, antibacterial, antifungal.- Bark considered astringent, emmenagogue, ecbolic and tonic.- Phytosterols from leaves considered antibacterial, hypoglycemic, antifungal, molluscicidal, cytotoxic.- Seeds considered anthelmintic, antispasmodic and antidiabetic.- Studies have suggested antibacterial, antifungal, antioxidant, antidiabetic, hypolipidemic, antiasthmatic, anticariogenic, nephroprotective, phytoremediative, anti-inflammatory, hepatoprotective properties.',
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
          'scientific_name': 'Premna odorata',
          'description':
              'Its fragrant leaves and is commonly used in traditional herbal medicine and aromatherapy.  Alagau is a medium-sized tree that can grow up to 12 meters (about 39 feet) tall. It has simple, opposite leaves with a strong and pleasant aroma when crushed. The leaves of the Alagau tree are elliptical, glossy, and dark green. They are often used for their aromatic qualities. Alagau trees are typically found in lowland and montane forests in the Philippines and other parts of Southeast Asia.',
          'family': 'Verbenaceae',
          'benifits':
              'The leaves of Alagau emit a distinct, sweet, and somewhat citrusy fragrance when crushed. This aroma is often used in herbal preparations and is believed to have medicinal properties. In traditional medicine, various parts of the Alagau tree are used to make remedies for various ailments, including coughs, colds, and fevers. The leaves are also used for their calming and soothing aroma in aromatherapy.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/alakaakpula1.jpeg',
          'image_paths': [
            'assets/images/alakaakpula1.jpeg',
            'assets/images/alakaakpula2.jpeg',
            'assets/images/alakaakpula3.jpeg',
            'assets/images/alakaakpula4.jpeg',
            'assets/images/alakaakpula5.jpeg',
          ],
          'local_name': 'Alakaak Pula',
          'scientific_name': 'Palaqium aureum Elm. Ex Merr.',
          'description':
              'Palaquium aureum is a hardwood tree that can reach heights of up to 25 meters. It is known for its valuable timber, which is used in various applications, including construction, furniture making, and boat building. The wood has a reddish-brown to dark brown color and is prized for its durability and resistance to decay. This tree species is found in various regions of the Philippines, particularly in lowland and mountain forests. The conservation status of Palaquium aureum may vary, but like many native tree species in the Philippines, it may face conservation challenges due to deforestation and habitat loss.',
          'family': 'Sapotaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The timber of Palaquium aureum is highly valued in the Philippines for its strength and resistance to termites. It is commonly used in traditional house construction, furniture, and other woodworking applications.',
        },
        {
          'path': 'assets/images/alim1.jpg',
          'image_paths': [
            'assets/images/alim1.jpg',
            'assets/images/alim4.jpg',
            'assets/images/alim5.jpg',
            'assets/images/alim6.jpg',
          ],
          'local_name': 'Alim',
          'scientific_name': 'Melanolepis multiglandulosa var',
          'description':
              'Alim is a shrub or small tree, 4 to 10 meters high, with stellate hairs giving a velvety appearance. Leaves are large, orbicular-ovate, 10 to 25 centimeters long, very broad, with a heart-shaped base, pointed at the tip, and often deeply three- to five-lobed, with coarsely toothed margins. Flowers are greenish yellow.',
          'family': 'Euphorbiaceae',
          'benifits':
              'Decoction of leaves used as vermifuge. - Bark used for chest pains; leaves or flowers on the wrist for fever. - In Papua, New Guinea, one of the plants used to treat centipede and snake bites. Bark is chewed, juice swallowed or rubbed on affected area.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/apitong1.jpeg',
          'image_paths': [
            'assets/images/apitong1.jpeg',
            'assets/images/apitong2.jpg',
            'assets/images/apitong3.jpeg',
          ],
          'local_name': 'Apitong',
          'scientific_name': 'Dipterocarpus grandiflorus Blanco',
          'description':
              'The Apitong tree, also known as the Philippine Mahogany, is one of the most sought-after trees in the timber industry. With its remarkable strength and durability,this forest giant has been used for various applications ranging from heavy-duty vehicle flooring to high-end furniture. But what makes it so expensive? Is planting Apitong profitable? And what are some of the alternatives available? In this blog post, well take a closer look at everything you need to know about this magnificent hardwood tree from its description and characteristics to its conservation status and more.',
          'family': 'Dipterocarpaceae',
          'benifits': 'Effective against rheumatism and liver diseases',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/bago1.jpg',
          'image_paths': [
            'assets/images/bago1.jpg',
            'assets/images/bago2.jpg',
            'assets/images/bago3.jpg',
          ],
          'local_name': 'Bago',
          'scientific_name': 'Gnetum gnemon L. Var',
          'description':
              'The bago tree is characterized by its glossy, elliptical leaves and can grow up to 25 meters in height. It produces small, yellowish-green flowers and oval-shaped fruits that are about 2-3 centimeters long. Melinjo is native to Southeast Asia and is commonly found in countries like Indonesia, Malaysia, and the Philippines.',
          'family': 'Gnetaceae',
          'benifits':
              'The seeds of *Gnetum gnemon* are the most valuable part. Known as belinjo or emping, these seeds are edible and have a slightly bitter taste. They are often used in various culinary preparations. The seeds are rich in protein, healthy fats, and essential minerals. They also contain antioxidants. In traditional medicine, various parts of the melinjo tree are used for their potential medicinal properties. Extracts from the leaves and bark have been studied for their antioxidant and anti-inflammatory effects.',
          'summary': '',
          'uses':
              'Bago seeds are commonly used in Indonesian cuisine. They are often processed into chips (emping) or used in traditional dishes, adding a unique flavor to the food. The seeds can be pressed to extract melinjo oil, which is used for cooking and has potential health benefits due to its nutritional content. Different parts of the tree, including leaves and bark, are used in traditional medicine for various purposes, including treating skin conditions and inflammation.',
        },
        {
          'path': 'assets/images/bagwakmorado1.jpeg',
          'image_paths': [
            'assets/images/bagwakmorado1.jpeg',
            'assets/images/bagwakmorado2.jpg',
            'assets/images/bagwakmorado3.jpeg',
            'assets/images/bagwakmorado4.jpeg',
            'assets/images/bagwakmorado5.jpeg',
          ],
          'local_name': 'Bagawak Morado',
          'scientific_name': 'Cierodendron pubescens',
          'description':
              'Bagawak Morad is one of the common names for this tree in the Philippines. The name Morado refers to its purplish flowers. Clerodendrum pubescens is a medium sized to large tree that can grow up to 25 meters about 82 feet in height. The leaves are typically simple, opposite, and have a somewhat rough or pubescent (hairy) texture, which is reflected in its scientific name. The tree produces clusters of small, tubular, and fragrant flowers. These flowers are often purplish in color and attract pollinators like butterflies and bees.After flowering, Clerodendrum pubescens produces small, fleshy, and often dark-colored fruits.',
          'family': 'Verbenaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'Bagawak Morado is known to have various traditional medicinal uses in the Philippines and other regions where it is found. Feer Reduction: The leaves of Bagawak Morado are sometimes used to prepare herbal remedies for reducing fever. They may be brewed into a tea or decoction and consumed for their potential antipyretic (fever-reducing) properties. Pain Relief: In traditional medicine, parts of the tree, including the leaves and bark, may be used to alleviate pain, such as headaches and body aches. Anti-Inflammatory: Some preparations made from Bagawak Morado are believed to have anti-inflammatory properties and may be used to treat inflammatory conditions. Antioxidant: The plant may contain compounds with antioxidant properties, which could help protect cells from oxidative stress and related health issues. Digestive Ailments In some traditional remedies, Bagawak Morado may be used to address digestive problems, such as indigestion or stomach discomfort. Wound Healing: Extracts or poultices made from various parts of the tree are sometimes applied topically to wounds or skin irritations to promote healing.',
        },
        {
          'path': 'assets/images/bahai1.jpg',
          'image_paths': [
            'assets/images/bahai1.jpg',
            'assets/images/bahai2.jpg',
            'assets/images/bahai3.jpeg',
          ],
          'local_name': 'Bahai',
          'scientific_name': 'Ormosia calavensis',
          'description':
              'Small sub-canopy tree (up to 20 m high); Bole cylindrical (up to 60 cm diam.); straight (bole up to 8 m long); buttresses buttresses present; spines spines absent; aerial roots aerial roots absent; stilt roots stilt roots absent; Bark grey or dark brown, rough, fissured or pustular, lenticels elongated vertically; Subrhytidome (under-bark) pale yellow; less than 25 mm thick; bark blaze with two layers; faintly to non-aromatic; outer blaze pale yellow, with stripes (brown); inner blaze white (cream-coloured), with stripes (brown); bark exudate (sap) absent; terminal buds not enclosed by leaves.',
          'family': 'Fabaceae/Papilionaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/balinghasay1.jpg',
          'image_paths': [
            'assets/images/balinghasay1.jpg',
            'assets/images/balinghasay2.jpg',
            'assets/images/balinghasay3.jpg',
            'assets/images/balinghasay4.jpg',
          ],
          'local_name': 'Balinghasai',
          'scientific_name': 'Buchanania arborescens',
          'description':
              'Balinghasay is a wide spread species growing in China, Taiwan, Myanmar, Andaman Islands, Indochina, Thailand, throughout Malesia (including Singapore) to New Britain (Papua New Guinea), Solomons Islands, and Australia.  It also grows in some parts of the Indian sub-continent and the Andaman Islands of India. It is a characteristic tree of the Australian rain forests growing along water courses in Northern Australia. Balinghasay trees bear heavy crops of small fruits which are edible but not of very good quality.  Though the fruits are not marketed, but these are used by local people and aboriginals in Australia. Fruits 1 celled drupe, 8-10 mm wide, lens shaped,  green flushed with purple-red with green flesh. Seeds 6-9 x 6-8 mm, compressed globular, Endocarp+/- 2-ribbed, dark brown, slightly less than 1 mm thick, very hard and difficult to cut.',
          'family': 'Anacardiaceae',
          'benifits':
              'Balinghasay fruits are edible but not so tasty.  Therefore these are not sold but are popularly eaten by local people and aborigines.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/balit1.jpeg',
          'image_paths': [
            'assets/images/balit1.jpeg',
            'assets/images/balit2.jpeg',
            'assets/images/balit3.jpg',
          ],
          'local_name': 'Balit',
          'scientific_name': 'Matthaea sancta Blume var vensulosa Perk.',
          'description':
              'Shrub or small tree, rarely to 15 m; Leaves lanceolate-oblong to oblong, 15.5-31 by 3.5-9.5 cm, acuminate, base broadly cuneate, truncate or rounded, chartaceous, often somewhat bullate, margin entire or dentate distally, glabrous; Inflorescences axillary, solitary or fascicled.',
          'family': 'Monimiaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The wood is heavy and branches are used in building houses. The leaves are smoked with tobacco to relieve headaches.',
        },
        {
          'path': 'assets/images/batikuling1.jpeg',
          'image_paths': [
            'assets/images/batikuling1.jpeg',
            'assets/images/batikuling2.jpeg',
            'assets/images/batikuling3.jpeg',
            'assets/images/batikuling4.jpeg',
          ],
          'local_name': 'Batikuling',
          'scientific_name': 'Litsea leytensis Merr.',
          'description':
              'Batikuling is a large tree widely found in the forests of Luzon, especially in Quezon Province. The batikuling wood is hard, pale in color and, at one time, was used for making agricultural tools handles and laundry paddles.',
          'family': 'Lauraceae',
          'benifits':
              'batikuling for woodcarving creates a continuing demand, which allows illegal loggers to thrive in business, as admitted by several people from Paete. In fact, illegal logging is the only way to acquire the batikuling in Paete, with carabao loggers or small-scale poachers coming all the way from Quezon Province. Other than this region, batikuling can also be found in Bataan, Sorsogon, Negros, and Leyte, but woodcarvers from Paete source their wood from nearby sources.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/batitinan1.jpeg',
          'image_paths': [
            'assets/images/batitinan1.jpeg',
            'assets/images/batitinan2.jpeg',
            'assets/images/batitinan3.jpeg',
          ],
          'local_name': 'Batitinan',
          'scientific_name': 'Lagerstroemia pyriformis Koehne',
          'description':
              'Batitinan commonly known as the pear-shaped Lagerstroemia or Pyriform Crapemyrtle, is a species of flowering tree native to Southeast Asia, particularly found in Vietnam. It belongs to the family Lythraceae. This deciduous tree is known for its attractive, peeling bark and clusters of showy, pear-shaped flower buds that resemble small fruits. The flowers bloom into white or pale pink blossoms, adding ornamental value to the tree. In addition to its aesthetic appeal, Lagerstroemia pyriformis is cultivated for its hardiness and ability to adapt to various soil types.',
          'family': 'Lythraceae',
          'benifits':
              'It provides ornamental value with its attractive peeling bark and clusters of pear-shaped flower buds, making it a popular choice in landscaping, while its adaptability to different soil types, resilience, and potential to offer shade contribute to its environmental and aesthetic benefits. Additionally, the tree may serve as habitat for wildlife, assist in soil erosion control, and hold cultural significance in certain regions.',
          'summary': '',
          'uses':
              'The heartwood is a light olive gray to dark grayish brown; the sapwood is whitish when fresh, turning grayish brown on exposure, it is sometimes a thin band 1 - 2cm wide and sharply demarcated, whilst at other times it can be 4 - 6cm wide and merging gradually into the heartwood. In wood from young, fast-growing trees the sapwood is hardly distinguishable from the heartwood after seasoning. The texture is fine and dense; the grain generally straight, sometimes with a short, very regular wave. The wood is hard; heavy; very durable, being rarely attacked even by termites or toredo. It seasons with little warping, but is liable to split badly at the ends; logs and freshly trimmed ends of sawn lumber should be painted to prevent splitting. The wood is rather difficult to work, but takes a beautifully smooth surface under sharp tools. It is used for purposes such as ship, wharf, and bridge building, including salt-water piles; ties; paving blocks; sills; posts; beams, joists, rafters; flooring, interior finish; furniture, cabinetwork.',
        },
        {
          'path': 'assets/images/batobato1.jpg',
          'image_paths': [
            'assets/images/batobato1.jpg',
            'assets/images/batobato2.jpg',
            'assets/images/batobato3.jpg',
            'assets/images/batobato4.jpg',
          ],
          'local_name': 'Bato-bato',
          'scientific_name': 'Drypetes littoralis Pax & K. Hoffm.',
          'description':
              'Trees; branches terete, glabrous. Petiole stout, 3-6 mm; leaf blade oblong to oblong-ovate, falcate, 6-10 by 3.5-5 cm, leathery, base acute or broadly cuneate, margin entire, apex obtuse or acute. Flowers not seen. Drupes solitary or 3- or 4-clustered, ellipsoid-ovoid, 12-15 by 8-10 mm; exocarp leathery, appressed-pubescent. Fr. May-Jun.',
          'family': 'Euphorbiaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'To protect food against pests, as an aphrodisiac, a stimulant/depressant, a rodenticide and a fish poison, against insect bites, to induce conception and for general healing.',
        },
        {
          'path': 'assets/images/betis.jpeg',
          'image_paths': [
            'assets/images/betis.jpeg',
            'assets/images/betis2.jpg',
            'assets/images/betis3.jpeg',
          ],
          'local_name': 'Betis',
          'scientific_name': 'Madhuca betis Macbr. & Merr.',
          'description':
              'Betis is a good-sized tree reaching a height of 30 meters. Bark is brown and ridged. Leaves are clustered at the ends of the branchlets, oblong-obovate, 20 to 25 centimeters long, 7 to 9 centimeters wide, smooth on the upper surface, very hairy beneath, pointed at both ends. Flowers are numerous, hairy, pale white, borne in rounded clusters. Fruit is ellipsoid, brownish, grows upon thickened smooth stalks, 3 to 4 centimeters long, with a large and shiny seed. Madhuca betis is a deciduous tree growing up to 35 metres tall. The bole can be up to 80cm in diameter.',
          'family': 'Sapotaceae',
          'benifits':
              'The bark and the leaves are used as a treatment for stomach pains in children. A latex obtained from the inner bark is applied to the abdomen in order to expel worms. The powdered bark is used as a snuff to provoke sneezing. The plant is listed as Vulnerable in the IUCN Red List of Threatened Species(1998) due to overexploitation and habitat destruction.',
          'summary': '',
          'uses':
              'Its fruit is gathered from the wild for local use as an oil for lamps etc. The timber is exploited locally.',
        },
        {
          'path': 'assets/images/bilis.jpeg',
          'image_paths': [
            'assets/images/bilis.jpeg',
            'assets/images/bilis2.jpeg',
            'assets/images/bilis3.jpeg',
          ],
          'local_name': 'Bilis',
          'scientific_name': 'Heterospathe sibuyanensis',
          'description':
              'Heterospathe is a monoecious genus of flowering plant in the palm family found in Oceania, where it is called sagisi palm. With 39 species, Heterospathe is named from a Greek combination of "various" and "spathe", which describes the two distinct bract types.',
          'family': 'Palmaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/binayuyu.jpg',
          'image_paths': [
            'assets/images/binayuyu.jpg',
            'assets/images/binayuyu2.jpeg',
            'assets/images/binayuyu3.jpeg',
          ],
          'local_name': 'Binayuyu',
          'scientific_name': 'Antidesma ghaesembilla',
          'description':
              'Binayuyo is a small deciduous tree growing to a height of 16 meters. Bark is light grey. Leaves are simple, alternate, shortly petioled, broadly elliptic or orbicular obovate, 6 to 11 centimeters long; margins entire and pubescent; base rounded, rarely obtuse; apex rounded, sometimes mucronate. Male flowers are yellowish green, grouped into much branched spikes. Sepals usually 5, with 4 to 5, 2 to 2.5 millimeters long stamens with filaments free. Female flowers are many, grouped in branched racemes with very short pedicels. Drupes are small, about 4.5 millimeters in diameter, dark purple when ripe and agreeably acid. A tree up to 20 m tall; young twigs pubescent. Stipules needlelike, 3-6 by 0.5-1 mm, pubescent, caducous; petiole 4-10 mm, pubescent; leaf blade oblong, more rarely ovate or obovate, 3-7 by 3-5 cm, papery to thinly leathery, pubescent to glabrous especially adaxially, often only major veins and margin pubescent, dull or shiny adaxially, dull abaxially, drying olive green to reddish green, base rounded to cordate, rarely obtuse, apex rounded, more rarely obtuse or acute, sometimes mucronate or retuse; domatia sometimes present; midvein flat adaxially, lateral veins 5-7 pairs, tertiary veins reticulate to weakly percurrent. Inflorescences axillary and terminal, axes reddish pubescent, males 4-8 cm, 1-20 branched, females 2-3 10-20 branched; fruiting 4-7 cm. Male flowers sessile; sepals  4 or 5, free, 0.5-1 mm, deltoid to oblong, pubescent outside, glabrous inside, apex acute to obtuse; disk consisting of 4-7 free alternistaminal obconical lobes, pubescent; stamens 4 or 5, 2-2.5 m; rudimentary ovary obconical. Female including fruiting pedicels 0-1 mm; sepals as in male; disk glabrous to pubescent especially at margin; ovary pubescent; stigmas  2 or 3. Drupes ellipsoid, laterally compressed, 3-4 by 2.5-3 mm, sparsely pubescent; style terminal to more rarely subterminal. ',
          'family': 'Phyllanthaceae',
          'benifits':
              'Leaves and fruits are edible. Fully ripe fruit can be eaten raw, cooked, pickled, or made into jams and jellies. In India, leaves used as vegetable in rural areas of Western Ghats. In Odisha, fruits used as ingredient in meat and fish curry preparations. Fruits are crushed and soaked in water to make a cordial-like drink. When eaten or drunk, lips and tongues are stained a blue-purple color. ',
          'summary': '',
          'uses':
              'Wood: Used for construction. fences, industrial and domestic woodware, tool handles. Calendar plant: In Australia, it is a calendar plant: during Gaynwarr, the cuckoo birds, dowo min (Mangarrrayi) or jowogban (Yangman) calls out during the buildup, telling the people that the fruit is ready for harvest. ',
        },
        {
          'path': 'assets/images/bakan1.jpeg',
          'image_paths': [
            'assets/images/bakan1.jpeg',
            'assets/images/bakan2.jpg',
            'assets/images/bakan3.jpeg',
          ],
          'local_name': 'Bakan',
          'scientific_name': 'Litsea philippinensis Merr',
          'description':
              'Bakan is a tree native to the Philippines prized for its oil-rich seeds used in traditional hair care, massage, and soap production, as well as for its potential in traditional medicine, , cultural importance, and applications in cosmetics and industry, while also benefiting local biodiversity',
          'family': 'Lauraceae',
          'benifits':
              'The benefits of the Bakan tree include its oil-rich seeds used in traditional hair care and soap making, its potential in traditional medicine, cultural significance, applications in cosmetics and industry, and its role in supporting local biodiversity.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/balakat1.jpeg',
          'image_paths': [
            'assets/images/balakat1.jpeg',
            'assets/images/balakat2.jpeg',
            'assets/images/balakat3.jpeg',
          ],
          'local_name': 'Balakat-gubat',
          'scientific_name': 'Sapium luzonicum',
          'description':
              'Balakat Gubat, is a medium-sized tree native to the Philippines, belonging to the Euphorbiaceae family; it reaches heights of about 15 meters, and its wood is utilized for construction and furniture, while certain parts are employed in traditional medicine by local communities. This tree is known for its timber and medicinal uses. ',
          'family': 'Euphorbiaceae',
          'benifits':
              'Balakat Gubat, offers several benefits. Its wood is valuable for construction and furniture, and parts of the tree are used in traditional medicine for their potential therapeutic properties. Additionally, the tree may have cultural significance in certain regions.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/banaibanai2.png',
          'image_paths': [
            'assets/images/banaibanai2.png',
          ],
          'local_name': 'Banai-banai',
          'scientific_name': 'Radermachera pinnata (Blanco) Seem.',
          'description':
              'It is a small tree with 30 cm diameter in the average. The bole is generally straight and regular, 8 to 12 m long. Buttresses up to 2 m high.',
          'family': 'Bignoniaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/basan1.jpg',
          'image_paths': [
            'assets/images/basan1.jpg',
            'assets/images/basan2.jpg',
            'assets/images/basan3.png',
          ],
          'local_name': 'Basan',
          'scientific_name': 'Garcinia garciae Scheff.',
          'description':
              'Basan commonly known as Malabar tamarind or Garcinia cambogia it is a tropical evergreen tree native to Southeast Asia. It produces small, pumpkin-shaped fruits that are yellow or green when ripe. ',
          'family': 'Guttiferae',
          'benifits':
              'The fruit is utilized in cooking, particularly in traditional South Asian dishes. It adds a sour flavor to curries and chutneys. Garcinia cambogia gained popularity for its alleged weight loss benefits. The peel of the fruit contains hydroxycitric acid (HCA), which some believe may help in weight management. The fruit is rich in antioxidants, which can help combat oxidative stress in the body. Garcinia cambogia has been used as a natural preservative for fish and other perishable foods due to its antimicrobial properties. It is essential to note that while some people believe in the weight loss benefits of Garcinia cambogia, scientific evidence supporting its effectiveness is limited, and its consumption should be approached with caution. Always consult with a healthcare professional before using it for medicinal purposes.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/batino1.jpeg',
          'image_paths': [
            'assets/images/batino1.jpeg',
            'assets/images/batino2.jpeg',
            'assets/images/batino3.jpeg',
          ],
          'local_name': 'Batino',
          'scientific_name': 'Alstonia macrophylla Wall. Ex DC',
          'description':
              'Batino tree is a medium-sized tree, growing up to 20 meters high. Bark is smooth. Branches are 4-angled. Leaves are in whorls of three, oblong-obovate, 10 to 30 centimeters long, 5 to 7 centimeters wide, and short-stalked.',
          'family': 'Apocynaceae',
          'benifits':
              'Batino is used as febrifuge, tonic, antiperiodic, antidysenteric, emmenagogue, anticholeric, and vulnerary.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/binukau1.jpg',
          'image_paths': [
            'assets/images/binukau1.jpg',
            'assets/images/binukau2.jpg',
            'assets/images/binukau3.jpg',
          ],
          'local_name': 'Binukau',
          'scientific_name': 'Garcinia binucao',
          'description':
              'Binukau is a fruit from South East Asia.  This is most abundant in low altitude forests in Philippines and Vietnam. Biucao is a sour fruit and is therefore mostly used as a souring agent in many local food recipes. An evergreen tree, upto 25 m tall, bole about 40 cm in diameter. Leaves obovate oblong, , 5-12 cm x 4-7 cm. Flowers unisexual, reddish to creamy white. Fruit a subglobose berry, about 4 cm in diameter, pulp juicy. Binucao fruits are sour.  So these cannot be eaten as such.  So these are used as a souring agent while cooking fish and other foods. Binucao fruits are collected from the wild only as it is still not cultivated.  The population of these wild trees is declining fast as the trees are logged for shifting cultivation.  So there is a great need for saving this species from extinction by planting trees. ',
          'family': 'Clusiaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/binunga1.jpg',
          'image_paths': [
            'assets/images/binunga1.jpg',
            'assets/images/binunga2.jpg',
            'assets/images/binunga3.jpg',
          ],
          'local_name': 'Binunga',
          'scientific_name': 'Macaranga tanarius',
          'description':
              'The binunga tree, scientifically known as Mangifera caesia, is native to Southeast Asia. It is commonly found in countries like Indonesia, Malaysia, and the Philippines. This evergreen tree can reach heights of 15-30 meters and has distinctive, elliptical leaves.',
          'family': 'Euphorbiaceae',
          'benifits':
              'Binunga trees contribute to the biodiversity of their native ecosystems by providing habitat and food for various wildlife species. ',
          'summary': '',
          'uses':
              'Binunga trees produce a fruit known as "binjai" or "wani" with a sweet and tangy taste. The fruit is consumed fresh or used in traditional dishes and desserts. Various parts of the binunga tree, including the bark and leaves, have been utilized in traditional medicine. They are believed to have properties that may help with conditions like diarrhea, skin issues, and fever. The timber from binunga trees is used for construction and making furniture due to its durability and resistance to termites.',
        },
        {
          'path': 'assets/images/bolongeta1.jpg',
          'image_paths': [
            'assets/images/bolongeta1.jpg',
            'assets/images/bolongeta2.jpg',
            'assets/images/bolongeta3.jpg',
          ],
          'local_name': 'Bolong-eta',
          'scientific_name':
              'Diospyros philippinensis var. philosanthera Blanco',
          'description':
              'A tree growing up to 20m and a diameter of 50cm. It has a greenish-black bark; light red inner bark. Flowers are dingy white, fruits are yellow-red with several black seeds. Observed to flower during March. It is also widely distributed in the Philippines. ',
          'family': 'Ebenaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'Wood used for fancy woodwork and furniture. Bark has reported medicinal properties.',
        },
        {
          'path': 'assets/images/busisi1.jpeg',
          'image_paths': [
            'assets/images/busisi1.jpeg',
            'assets/images/busisi2.jpeg',
            'assets/images/busisi3.jpg',
          ],
          'local_name': 'Busisi',
          'scientific_name': 'Melastoma malabathricum',
          'description':
              'Busisi is a spreading shrub growing to a height of 2 meters. Twigs and flower stalks are rough with small, triangular, upward pointing scales. Leaves are broadly lanceolate, 7 to 12 centimeters long, slightly rough and hairy on both surfaces. Flowers are 4 to 7 centimeters across, clustered, and mauve purple. Calyx is closely set with short, chaffy, silky or silvery scales. Fruit is ovoid, about 6 millimeters wide and pulpy within.',
          'family': 'Melastomataceae',
          'benifits':
              'Melastoma malabathricum is believed to offer potential health benefits, as some traditional practices use its parts for medicinal purposes, suggesting antioxidant and anti-inflammatory properties that may contribute to overall well-being.',
          'summary': '',
          'uses':
              'The Melastoma malabathricum tree has diverse uses, with its leaves and roots being employed in traditional medicine for treating ailments, while its berries are utilized in culinary practices or as a source of natural dyes in certain regions.',
        },
        {
          'path': 'assets/images/dalingdingan1.jpg',
          'image_paths': [
            'assets/images/dalingdingan1.jpg',
            'assets/images/dalingdingan2.jpg',
            'assets/images/dalingdingan3.jpg',
          ],
          'local_name': 'Dalingdingan',
          'scientific_name': 'Hopea foxworthyi Elem.',
          'description':
              'Dalingdingan is a species of tree in the family Dipterocarpaceae. It is endemic to the Philippines. Locally called manggachapui and also dalingdingan, it is a hard straight grained wood that was used to build the early Manila galleons; it having qualities of being so dense as to not be affected by wood boring insects and one supposes marine worms.',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/dolalog.jpeg',
          'image_paths': [
            'assets/images/dolalog.jpeg',
            'assets/images/dolalog1.jpg',
            'assets/images/dolalog2.jpeg',
            'assets/images/dolalog3.jpeg',
          ],
          'local_name': 'Dolalog',
          'scientific_name': 'Ficus variegata var. sycomoroides',
          'description':
              'Dolalog is a well distributed species of tropical fig tree. It occurs in many parts of Asia, islands of the Pacific and as far south east as Australia. There is a large variety of local common names including common red stem fig, green fruited fig and variegated fig. Ficus variegata is a species of fig tree found throughout Southeast Asia, often growing on forested floodplains or towns edges. Also known as the variegated fig or red-stem fig, it is a fast-growing tree that reaches 7 to 37 m 23 to 120 ft high. Its leaves are large and heart-shaped. The tree is easily recognized by its cauliflory, meaning that fruit grows directly out of its trunk. These edible, red-brown figs are about a half inch in diameter. As the species is dioecious, there are male and female trees. Specialized fig wasps carry out pollination by breeding inside the figs, part of a mutually beneficial relationship, and the trees flower asynchronously to support the wasps throughout the year. Ficus variegata interacts with many other animals; its fruit is eaten and seeds dispersed by as many as 41 species, including fruit bats, orangutans, gibbons, wild pigs, and deer. The tree also produces a kind of wax used in the art of batik, a method of resist-dyeing to create patterned textiles.',
          'family': 'Moraceae',
          'benifits':
              'According to Burkill, the fibrous bark is used by jungle natives to make a felt-like cloth used for loin cloths. The sweet bark is chewed or the fruits used instead, to cure dysentery. In the past the latex was used in the batik industry. The fruits are apparently only eaten in times of famine and Burkill said that no European could stomach them.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/isis.jpeg',
          'image_paths': [
            'assets/images/isis.jpeg',
            'assets/images/isis1.jpeg',
            'assets/images/isis2.jpeg',
          ],
          'local_name': 'Is-is',
          'scientific_name': 'Ficus ulmifolia',
          'description':
              'Is-is is a shrub or small tree, 3-5 m tall. Leaves are alternate,variable in shape, subentire, undulately lobed or coarsely toothed, sometimes deeply or narrowly lobed, base rounded and three nerved, 9-17 cm by 4-8 cm. Fruit is a fig, subglobose, about 1.5 cm long, orange-red to purple, axillary, solitary or in pairs, edible.',
          'family': 'Moraceae',
          'benifits':
              'Fruits are edible, although with little flavor, sometimes eaten with sugar and cream. Leaves used in the treatment of allergy, asthma, diarrhea, diabetes, tumor and cancer. Scouring: Young leaves are used to clean cooking utensils and to scour wood floors, stairs, etc. Broiler supplement: Study showed applicability and benefits for use of the fruit as supplements to commercial mash, which resulted in significant weight gain and better animal performance. Repellent: Ayta people of Pampanga burn leaves and stem as mosquito repellent. Wood: Used for crafts and furniture making.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/kahoydalaga2.jpeg',
          'image_paths': [
            'assets/images/kahoydalaga2.jpeg',
            'assets/images/kahoydalaga3.jpeg',
            'assets/images/kahoydalaga4.jpeg',
            'assets/images/kahoydalaga5.jpeg',
          ],
          'local_name': 'Kahoy dalaga',
          'scientific_name': 'Mussaenda magallanensis Elm. Ex Merr.',
          'description':
              'Kahoy dalaga is a genus of flowering plants in the family Rubiaceae. They are native to the African and Asian tropics and subtropics. Several species are cultivated as ornamental plants.',
          'family': 'Rubiaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/kalingag.jpeg',
          'image_paths': [
            'assets/images/kalingag.jpeg',
            'assets/images/kalingag1.jpg',
            'assets/images/kalingag2.jpeg',
            'assets/images/kalingag3.jpeg',
          ],
          'local_name': 'Kalingag',
          'scientific_name': 'Cinnamomum mercadoi',
          'description':
              'The kalingag is a small tree that reaches a height of six to 10 meters. It has a thick and aromatic bark used to make cinnamon. Kalingag trees also do not need to be watered frequently. It can thrive well in an area that receives an abundance of rainfall during the wet season. But in the dry season, Canieso-Yeo suggests watering the trees once or twice a week or if the soil is dry.',
          'family': 'Lauraceae',
          'benifits':
              'Decoction or infusion of the bark used for loss of appetite, bloating, vomiting, flatulence, toothache, headaches, rheumatism, dysentery, to help expel flatus and to facilitate menses; colds, fevers, sinus infections and bronchitis.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/katmon1.jpg',
          'image_paths': [
            'assets/images/katmon1.jpg',
            'assets/images/katmon2.jpg',
            'assets/images/katmon3.jpg',
          ],
          'local_name': 'Katmon',
          'scientific_name': 'Dillenia philippinensis Rolfe',
          'description':
              'Katmon is small to medium sized evergreen tree about 6-15 meters high with an erect to contorted bole with slight buttresses and smooth, greyish brown and shallowly fissured bark. Leaves are elliptic, large, 12 25 cm long, thick, coraiceous, glabrous and glossy green having serrated margins and prominently penni-veined. Flowers are large, white, showy and about 15 cm across. Flowers are five pale green cup shaped sepals, five obovate and spreading white petals. Outer stamens are shorter, slightly spreading and forms basket like structure. They are dark red with white tips in upper half of the length and yellow in basal half. Stamens have short stout filaments and long anthers. Carpels have separate firm radiating stylar branch with small concave stigma at the tip. Fruit is globose, 5-6 cm across made up of fleshy, imbricate and thin sepals which encloses syncarpous aggregate of carpels. Each carpel contains 1 to 5 small brownish-black seeds embedded in a soft and gelatinous pulp.',
          'family': 'Dilleniaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/kalomala1.png',
          'image_paths': [
            'assets/images/kalomala1.png',
          ],
          'local_name': 'Kalomala',
          'scientific_name': 'Elaeocarpus calomala Merr.',
          'description':
              'Elaeocarpus calomala is a tree commonly found in the Philippines and used to create religious images known as santo. In the Philippines this tree is locally known as anakle, bunsilak or binting-dalaga (Tagalog, "maidens leg"). It is similar to native tree species known as batikuling and like the olongas, another native tree species in the Philippines. Kalomala is an evergreen tree that can grow up to 25 metres tall, The bole can be up to 60cm in diameter.',
          'family': 'Elaeocarpaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The plant is harvested from the wild for local use as a food and source of fibre.',
        },
        {
          'path': 'assets/images/kansilay1.jpg',
          'image_paths': [
            'assets/images/kansilay1.jpg',
            'assets/images/kansilay2.jpg',
            'assets/images/kansilay3.jpg',
          ],
          'local_name': 'Kansilay',
          'scientific_name': 'Cratoxylum sumatranum',
          'description':
              'Kalansilay, commonly known as the Vietnamese Pear or Sawtooth Oak, is a tree native to Southeast Asia. It is a deciduous tree with distinctive serrated leaves, the tree can reach a height of 25 meters. Flowers are small and greenish, and the fruit is a capsule containing seeds. ',
          'family': 'Hypericaceae',
          'benifits':
              'Various parts of the tree, including the bark and leaves, are used in traditional medicine for treating ailments such as fever, diarrhea, and inflammation. The timber from Cratoxylum sumatranum is used in construction and furniture making due to its durability and resistance to decay. ',
          'summary': '',
          'uses':
              'In some regions, parts of the tree are used in local cuisines, and the fruit can be consumed. The tree contributes to environmental conservation by providing shade and supporting biodiversity.',
        },
        {
          'path': 'assets/images/kubi1.jpeg',
          'image_paths': [
            'assets/images/kubi1.jpeg',
            'assets/images/kubi2.jpeg',
            'assets/images/kubi3.jpeg',
            'assets/images/kubi4.jpg',
          ],
          'local_name': 'Kubi',
          'scientific_name': 'Artocarpus nitidus ssp, nitidus',
          'description':
              'Kubi is a medium-sized tree growing to a height of 15 meters. Bark is black to brown, longitudinally fissured.  . Branchlets are cylindric, wrinkled, 2 to 3 millimeters thick, appressed puberulent, rapidly glabrescent. Leaves are oblong-ovate, acute, up to 12 centimeters long and 5 centimeters wide. with prominent veins. Flowers are small. Fruits are irregularly-shaped, 4 to 8 centimeters in diameter, several seeded and covered with yellowish brown or gray tomentum.',
          'family': 'Moraceae',
          'benifits':
              'The wood can be used for light construction, while the trunk serves as posts for bridges. The fruits are edible. The sap extracted from the bark is used to cure leprosy.The wood is used as terap or keledang, e.g. in house building and light construction. The fruit is edible, but not very tasty. Bark and roots are sometimes added to betel.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/lanetenggubat1.jpg',
          'image_paths': [
            'assets/images/lanetenggubat1.jpg',
            'assets/images/lanetenggubat2.jpg',
          ],
          'local_name': 'Laneteng Gubat',
          'scientific_name': 'Kibatalia gitingensis (Elmer) Woodson',
          'description':
              'A small to medium-sized tree up to 30(-50) m tall, bole straight, up to 100 cm in diameter, sometimes fluted at the base or with small buttresses, outer bark blackish-brown to grey, smooth or rough, minutely scaly, tuberculate, or fissured, inner bark cream, with broken, orange-yellow laminations, without latex; leaves in whorls of 3-4, obovate or narrowly obovate, sometimes elliptical to narrowly elliptical, 4.5-25(-32) cm x 1.5-10.5 cm, apex rounded to narrowly acuminate, with 12-25(-31) pairs of secondary veins, petiole 2-25 mm long; inflorescence many-flowered, pedicel 1-4 mm long, calyx laxly puberulous to glabrous, corolla glabrous outside; follicles glabrous, which are placed in pairs and filled with many wind dispersed hairy seeds. ',
          'family': '',
          'benifits': '',
          'summary': '',
          'uses':
              'Used for medicine, food, and wood source for instruments, shoes, and other handicrafts. This native tree is classified as Vulnerable in the IUCN Red List of Threatened Species (2013). “Protect our trees, our forests- our source of life!',
        },
        {
          'path': 'assets/images/liuin1.jpg',
          'image_paths': [
            'assets/images/liuin1.jpg',
            'assets/images/liuin2.jpg',
            'assets/images/liuin3.jpg',
          ],
          'local_name': 'Liuin',
          'scientific_name': 'Maranthes corymbosa',
          'description':
              'Liuin is usually a tree growing up to 40 metres tall, but can be no more than a shrub when growing on dunes by the coast. The straight, cylindrical bole is up to 60cm in diameter and can be unbranched for 10 - 20 metres; it is not buttressed. The plant is harvested from the wild for local use as a food and source of wood. The plant is classified as Least Concern in the IUCN Red List of Threatened Species(2011)',
          'family': 'Chrysobalanaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malapapaya1.jpg',
          'image_paths': [
            'assets/images/malapapaya1.jpg',
            'assets/images/malapapaya2.jpg',
          ],
          'local_name': 'Malapapaya',
          'scientific_name': 'Polyscias nodosa Seem.',
          'description':
              'Malapapaya is a tall tree reaching a height of about 25 m and a diameter of about 50 cm. Leaves are crowded on twig-apices, widely spreading-downward, simple pinnate, 1-2 mm long; petiole is one third of the length of pinnate leaf; leaflets ovate-oblong, lanceolate from a rounded base, narrowed or shortly acuminate, rounded scallop to saw-tooted edge, 10-25 cm long, and 4-10 cm wide; petiole is very short, more or less 1 cm long. Leaf-blade on the upper surface has distinct fine soft spine in the seedling stage. Inflorescences in panicles ( sometimes with additional flowering branches in the axils of the upper leaves); primary axils stout, about 1.5 m; bearing secondary axils along its length, bract triangular, about 5 mm long; secondary axils about 20 to 40 cm; capitula borne racemosely along the secondary branches on peduncles about 6-15 cm long. Flowers are attached directly to a branch, capitate, 8-12 in capitulum. Petals are broadly oblong, valvate, acute, yellowish green, usually 2 mm. Fruits are subglobose, ridged and yellowish red when dry.',
          'family': 'Araliaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malaruhatpula1.jpeg',
          'image_paths': [
            'assets/images/malaruhatpula1.jpeg',
            'assets/images/malaruhatpula2.jpg',
          ],
          'local_name': 'Malaruhat pula',
          'scientific_name': 'Syzygium decipiens',
          'description':
              'Syzygium decipiens is a tree that can grow from 15 - 30 metres tall. The straight, cylindrical bole can be free of branches for more than half the trees height, 20 - 30cm in diameter with buttresses. The tree is sometimes harvested from the wild for its wood, which is traded.',
          'family': 'Myrtaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The heartwood is a golden brown, greyish brown or brown, with pink or purplish glints; it is not clearly demarcated from the 1 - 4cm wide band of sapwood. The texture is fine; the grain slightly interlocked, sometimes wavy or irregular; there are resin deposits. The wood is heavy; moderately hard; somewhat durable, being moderately resistant to fungi and termites, but susceptible to dry wood borers. It seasons slowly, with a high risk of checking and distortion; once dry it is moderately stable in service. It works well with ordinary tools, nailing and screwing are good so long as the wood is pre-bored; gluing is correct. The wood is used for musical instruments, tool handles, furniture components, ship building, heavy carpentry, flooring, joinery etc.',
        },
        {
          'path': 'assets/images/malaruhatputi1.jpeg',
          'image_paths': [
            'assets/images/malaruhatputi1.jpeg',
            'assets/images/malaruhatputi2.jpeg',
            'assets/images/malaruhatputi3.jpeg',
          ],
          'local_name': 'Malaruhat puti',
          'scientific_name': 'Syzygium bordenii',
          'description': '',
          'family': 'Myrtaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malasantol1.jpeg',
          'image_paths': [
            'assets/images/malasantol1.jpeg',
            'assets/images/malasantol2.jpeg',
            'assets/images/malasantol3.jpeg',
          ],
          'local_name': 'Malasantol',
          'scientific_name': 'Sandoricum vidalii Merr.',
          'description':
              'Santol is a large, ornamental evergreen tree with a dense, narrowly oval crown; it usually grows around 25 metres tall but with some specimens up to 50 metres. The bole, which is sometimes straight but often crooked or fluted, is branchless for up to 18 metres; has a diameter up to 100 cm; and buttresses up to 3 metres high[303, 459]. The tree yields an edible fruit that is popular in parts of the tropics. It also has a wide range of traditional medicinal uses and produces a useful timber. It is often cultivated in tropical areas, especially for its edible fruit and as an ornamental in parks, along roads etc.',
          'family': 'Meliaceae',
          'benifits':
              'Sandoricum vidalii Merr. is valued for its fruit, which, when consumed, may provide essential nutrients and potential health-promoting compounds, contributing to a balanced diet and overall well-being. Additionally, the tree may have applications in traditional medicine or local practices, although the extent of such uses can vary regionally.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/mangasinoro1.jpg',
          'image_paths': [
            'assets/images/mangasinoro1.jpg',
            'assets/images/mangasinoro2.jpg',
            'assets/images/mangasinoro3.jpg',
          ],
          'local_name': 'Mangasinoro',
          'scientific_name': 'Hopea philippinensis Brandis',
          'description':
              'Hopea philippinensis is a small tree. The bole is buttressed .Although somewhat on the small size, the tree is still harvested commercially for its wood, which is used localy as a source of merawan.The tree is threatened by habitat destruction due to human activity. The plant is classified as Critically Endangered in the IUCN Red List of Threatened Species.',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The tree is a source of merawan timbe.We have no more specific information for this tree at present, but the general description of merawan wood is as follows:- The heartwood is yellow-brown to chocolate reddish-brown, with an occasional dark striping; it is not clearly demarcated from the 5 - 7cm wide band of light yellow-brown sapwood. The texture is fine to medium; the grain straight or interlocked; lustre is rather low; without distinctive odour or taste. The wood is moderately heavy; moderately hard; moderately durable, being resistant to dry wood borers, moderately resistant to fungi but susceptible to termites. It seasons slowly, with a high risk of checking and distortion; once dry it is moderately stable in service. It can be worked with ordinary tools; it is moderately easy to resaw and cross-cut; planing is fairly easy and the surface produced is smooth; the wood tends to split when nailing or screwing and nail holding is poor; gluing is correct; there is some resistance to acids. The wood has a wide range of applications, for purposes such as light construction, door and window frames, carpentry, flooring, joinery, turnery and veneer.',
        },
        {
          'path': 'assets/images/manggachapui1.jpg',
          'image_paths': [
            'assets/images/manggachapui1.jpg',
            'assets/images/manggachapui2.jpg',
            'assets/images/manggachapui3.jpg',
            'assets/images/manggachapui4.jpg',
          ],
          'local_name': 'Manggachapui',
          'scientific_name': 'Hopea acuminata',
          'description':
              'Outer bark brown, smooth when young fissured to flaky when mature; inner bark light brown. Leaves alternate, simple, elliptical-falcate to ovate-lanceolate, 4.5-12 x 2-4.5 cm; base unequal and wedge-shaped, apex acuminate; lateral nerves 9-12 pairs; petiole 6-10 mm long. Flowers axillary or terminal, panicles, 3.5cm long, each branchlet with 3-9 flowers; stamens 10. Fruits with pedicels 2mm long, with two prominent long wings 2-55 x 6-10 mm, spatulate, obtuse, narrowed towards the base, green, turning dark brown when dry; the three other fruit sepals shorter than the nut; nut (6x4mm) broadly ovoid.',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'WOOD USES: For bridges and heavy construction for which wood of great strength is required. It is preferred for door and window frames, and it is often used in place of Guijo for high grade construction. NON-WOOD USES: Bark contains tannin which can be used for leather production and in tannin-formaldehyde adhesive ENVIRONMENTAL SERVICES: Windbreaks and good for soil erosion control.',
        },
        {
          'path': 'assets/images/maganhop1.jpg',
          'image_paths': [
            'assets/images/maganhop1.jpg',
            'assets/images/maganhop2.jpg',
          ],
          'local_name': 'Maganhop',
          'scientific_name': 'Albizia lebbekoides (DC.) Benth',
          'description':
              'Maganhop is a small to medium-sized tree, 8-15(-32) m tall, trunk up to 40(-80) cm in diameter; branches terete, glabrous, with grayish bark. Leaves alternate, minutely stipulate, bipinnately compound with 5-13 cm long rachis provided with glands near base and top; petiole 2.5-6 cm long; pinnae in 3-8 pairs, with glandular axis, 5-15 cm long; leaflets (5-)15-25(-35) pairs per pinna, (narrowly) oblong, 6-20 mm 2-6 mm, asymmetric and truncate at base, mucronate at apex, sessile. Flowers in axillary up to 18 cm long panicles composed of 10-15-flowered heads; calyx narrowly campanulate, very small; corolla tubular, 3.5-5 mm long, 5-lobed; stamens numerous, 7-10 mm, filaments united into a tube; ovary superior, sessile and glabrous. Fruit a strap-shaped dehiscent pod, 7-15(-20) cm  1.5-2 cm, glabrous, chartaceous and dark brown. Seeds up to 12 per pod, obovate or suborbicular, 4.5-7 mm  3.5-5 mm  1-1.5 mm, areolate. Specimens aberrant with regard to the width of the pod (up to 2.8 cm), and the size of the leaflets (up to 27 mm 14 mm) occur on the Lesser Sunda Islands, but no varieties are recognized.',
          'family': 'Leguminosae',
          'benifits':
              'In Cambodia, bark used for treatment of colic and diarrhea.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/magobuyo1.jpg',
          'image_paths': [
            'assets/images/magobuyo1.jpg',
            'assets/images/magobuyo2.jpeg',
            'assets/images/magobuyo3.jpeg',
            'assets/images/magobuyo4.jpeg',
            'assets/images/magobuyo5.jpeg',
          ],
          'local_name': 'Magobuyo',
          'scientific_name': 'Celits luzonica',
          'description':
              'Magobuyo Luzon hackberry, magobuyo (in the Philippines) is a tree that can reach heights of up to 25 meters (about 82 feet). It has a rounded crown and typically has a single trunk. The leaves are simple, alternate, and typically serrated along the edges. They are generally ovate or elliptic in shape and have a dark green color. The tree produces small, fleshy, and sweet-tasting fruits that are often eaten by birds and other wildlife. These fruits are typically reddish or brown when ripe.',
          'family': 'Ulmaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The sweet fruits of Celtis luzonica are sometimes collected and eaten by people in the Philippines. They are also a food source for wildlife. Wood: The wood of the Luzon hackberry may be used for various purposes, including making furniture and small wooden items. It is valued for its hardness and durability. Rates of habitat loss through logging and shifting cultivation have led to considerable population declines. The plant is classified as Vulnerable in the IUCN Red List of Threatened Species.',
        },
        {
          'path': 'assets/images/malabog1.png',
          'image_paths': [
            'assets/images/malabog1.png',
            'assets/images/malabog2.png',
          ],
          'local_name': 'Malabog',
          'scientific_name': 'Parishia malabog Merr.',
          'description':
              'A medium-sized tree up to 25 m tall, bole generally straight and regular, up to 60(-120) cm in diameter; leaves with 4-7 pairs of leaflets, leaflets asymmetrical or oblique at base, petiolules flat or convex above; flowers subsessile, petals elliptical to elliptical-oblong, up to 4 mm long, pinkish; fruit ovoid, c. 2 cm long, fruit calyx with c. 1.5 cm long tube and 5.5-10 cm long wing-like lobes, red when young and becoming brownish in ripe fruit. P. malabog occurs on forested slopes and rocky hills at low altitudes, also on rocky cliffs near the seashore, and is locally common. The density of the wood is 610-755 kg/m3at 15% moisture content.',
          'family': 'Anacardiaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The wood is used for temporary construction and cheap grades of veneer and plywood; it is also used for making canoes.',
        },
        {
          'path': 'assets/images/malapaho2.png',
          'image_paths': [
            'assets/images/malapaho2.png',
            'assets/images/malapaho3.png',
            'assets/images/malapaho.png',
          ],
          'local_name': 'Malapaho',
          'scientific_name': 'Mangifera monandra Merr',
          'description':
              'A medium-sized to fairly large tree, with bole branchless for up to 20 m and up to 120 cm in diameter, buttresses absent. Leaves elliptical to obovate-lanceolate or almost spatulate, 8-19 cm 2.5-8 cm. Inflorescence pseudo-terminal, lax and many-flowered, glabrous. Flowers 4-merous, petals 3-4.5 mm long, white, with 5(-7) ridges confluent at the base, disk cushion-like, slightly 4-lobed, one stamen fertile, staminodes much smaller, filaments free. Fruit ellipsoid, slightly compressed and inequilateral, c. 3.5 cm long.',
          'family': 'Anacardiaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The wood is used for interior finish, furniture, cabinet work and construction under cover. The fruit is usually eaten unripe, because when ripe it becomes difficult to recover the little flesh there is.',
        },
        {
          'path': 'assets/images/malapanau1.jpg',
          'image_paths': [
            'assets/images/malapanau1.jpg',
            'assets/images/malapanau2.png',
            'assets/images/malapanau3.jpg',
          ],
          'local_name': 'Malapanau',
          'scientific_name': 'Dipterocarpus kerii',
          'description':
              'Malapanau is a medium-sized to fairly large tree of up to measure 40 m tall, tall bole, branchless for up to measure 25 m, with a size up to measure 150 cm in diametre and blunt buttresses. The bark surface is non-fissured, dark grey to yellowish-grey in colour and flaky. The outer bark is thin and grey while the inner bark is pinkish-brown in colour, brittle and with pale ochre sapwood. The buds are lance-shaped-falcate and hairless. The leaves are broadly elliptical in shape, measuring about 8-13 cm x 3.3-7 cm, wedge-shaped base and up to 5 mm long acumen. The secondary veins are (7-)9-11 pairs, ascending, hairless, 2-3 cm long petiole, linear-lance-shaped stipules, subacute and silky hairy inside. The stamens are about 30. The fruit sepal tube is spherical to subturbinate and smooth, where the 2 larger fruit sepal lobes are up to measure 14 cm x 3 cm while the 3 shorter ones are up to 1 cm x 1 cm.',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malabuho1.jpeg',
          'image_paths': [
            'assets/images/malabuho1.jpeg',
            'assets/images/malabuho2.jpeg',
            'assets/images/malabuho3.jpeg',
            'assets/images/malabuho4.jpeg',
          ],
          'local_name': 'Malabuho',
          'scientific_name': 'Sterculia oblongata R. Br.',
          'description':
              'Malabuho is a medium to large-sized tree that can reach heights of up to 30 meters (about 100 feet). The leaves are typically compound, with multiple leaflets arranged along a central stem. The tree produces small, greenish-yellow flowers that are often inconspicuous. Sterculia oblongata produces distinctive, long, and cylindrical seed pods. These pods can be quite large and contain seeds.',
          'family': 'Sterculiaceae',
          'benifits':
              'Traditional Medicine: In traditional Filipino medicine, parts of the Malabuho tree, including the seeds and bark, are believed to have medicinal properties. They are used in remedies to treat various ailments, although it is important to note that scientific validation of these uses may be limited. Cultural and Ritual Uses: Some indigenous communities in the Philippines may incorporate Malabuho in cultural and ritual practices. The tree and its products may have symbolic significance in these contexts. Crafts and Carving: The wood of Malabuho is sometimes used by local artisans for carving and crafting. Its attractive grain and durability make it suitable for creating decorative and functional items.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malagbignai1.jpg',
          'image_paths': [
            'assets/images/malagbignai1.jpg',
            'assets/images/malagbignai2.jpg',
          ],
          'local_name': 'Malabignai',
          'scientific_name': 'Aporosa symplocifolia Merr',
          'description':
              'Malagbignai commonly known as Merr tree, is a tropical tree found in Southeast Asia. Typically found in lowland and montane forests. Medium-sized tree with simple, alternate leaves. The bark is often smooth, and the tree may bear small flowers and fruits. It is essential to note that specific uses and benefits can vary across cultures, and further scientific research may be needed to fully understand the potential applications of Aporosa symplocifolia.',
          'family': 'Euphorbiaceae',
          'benifits':
              'Some communities use parts of Aporosa symplocifolia for traditional medicinal purposes. The bark or leaves may be employed in herbal remedies. The tree contributes to the ecological diversity of its habitat, providing resources for various organisms.',
          'summary': '',
          'uses':
              'In some cases, the wood may be used for local construction or crafting purposes. ',
        },
        {
          'path': 'assets/images/malakadios1.jpeg',
          'image_paths': [
            'assets/images/malakadios1.jpeg',
            'assets/images/malakadios2.jpg',
            'assets/images/malakadios3.jpg',
          ],
          'local_name': 'Malakadios',
          'scientific_name': 'Dehaasia cairocan',
          'description': '',
          'family': 'Lauraceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/malakape.jpg',
          'image_paths': [
            'assets/images/malakape.jpg',
            'assets/images/malakape2.jpeg',
            'assets/images/malakape3.jpeg',
          ],
          'local_name': 'Malakape',
          'scientific_name': 'Canthium decocum',
          'description': '',
          'family': 'Rubiaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/marang1.jpeg',
          'image_paths': [
            'assets/images/marang1.jpeg',
            'assets/images/marang2.jpeg',
            'assets/images/marang3.jpeg',
          ],
          'local_name': 'Marang',
          'scientific_name': 'Litsea perrottetii F.-Vill',
          'description':
              'Marang is a fruiting tree with an upright crown and, sometimes, buttressed roots. A member of the mulberry family and closely related to jackfruit and breadfruit, marang is also a tropical fruit. Its origins are Borneo, Palawan, and Mindanao Island.',
          'family': 'Lauraceae',
          'benifits':
              'It can also be used to make jams, jellies, or other sweet treats. Additionally, the leaves of the Marang tree are sometimes used to wrap foods, adding flavor and keeping the food fresh. The Marang fruit is a good source of several vitamins and minerals, including vitamin C, vitamin A, folate, and potassium.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/molato.jpeg',
          'image_paths': [
            'assets/images/molato.jpeg',
            'assets/images/molato2.jpeg',
          ],
          'local_name': 'Molato',
          'scientific_name': 'Palaquium dubardii Elm',
          'description': '',
          'family': 'Sapotaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/nangkaon1.jpg',
          'image_paths': [
            'assets/images/nangkaon1.jpg',
            'assets/images/nangkaon2.jpg',
          ],
          'local_name': 'Nangkaon',
          'scientific_name': 'Elaeocarpus candollei Elm.',
          'description':
              'It is commonly known as "Wild Olive," is a tree native to Southeast Asia. Its elliptical leaves are dark green, and it produces small, white flowers followed by olive-like fruits.',
          'family': 'Elaeocarpaceae',
          'benifits':
              'In traditional medicine, various parts of the tree, such as the bark and leaves, are used for their potential health benefits.',
          'summary': '',
          'uses':
              ' These may include anti-inflammatory properties and the treatment of ailments like diarrhea and skin disorders. However, scientific research on its medicinal properties is limited, so it is essential to consult with a healthcare professional before using it for therapeutic purposes.',
        },
        {
          'path': 'assets/images/mangasinoro1.jpg',
          'image_paths': [
            'assets/images/mangasinoro1.jpg',
            'assets/images/mangasinoro1.jpg',
          ],
          'local_name': 'Mangasinoro',
          'scientific_name': 'Hopea philippinensis Brandis',
          'description':
              'Small, smooth-barked buttressed tree. Twigs, petioles, domatia, leaf bud, stipules and parts of petals exposed in bud densely persistently pale tawny pubescent; Leaves (7-) 12-25 by (2.5-)4-7 cm, narrowly elliptic-oblong to lanceolate, thinly coriaceous; Stamens 15, slightly shorter than style at anthesis; Panicle to 5 cm long, 1-axillary to ramiflorous, slender, rather lax, singly branched; Ovary and stylopodium hour-glass shaped, the ovary slightly the broader.',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/nato1.jpg',
          'image_paths': [
            'assets/images/nato1.jpg',
            'assets/images/nato2.jpg',
            'assets/images/nato3.jpg',
          ],
          'local_name': 'Nato',
          'scientific_name': 'Palaquium luzoniense Vid',
          'description':
              'Nato also known as Palaquium luzoniense, is a large evergreen tree that can grow up to 45 meters in height. Its trunk has a diameter of around 1 meter and its crown is made up of dense foliage. The heartwood of the Red Nato tree is a vibrant red color that darkens with age. It is highly valued for its beautiful appearance and durability, as it has a high density and hardness level. The leaves of this tree are elliptical or oblong-shaped with pointed tips. They have smooth edges and are arranged alternately on the branches. The young leaves are bright green in color but turn darker as they mature.',
          'family': 'Sapotaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The timber forms the bulk of "red nato" in the Philippines. It is used for furniture and cabinet making, cigar boxes and ship planking; it is also suitable for veneer and plywood. The latex is used for making gutta-percha. Palaquium luzoniense, also called red nato, is a species of plant in the family Sapotaceae. It is endemic to the Philippines. It is threatened by habitat loss.',
        },
        {
          'path': 'assets/images/niyogniyog1.jpeg',
          'image_paths': [
            'assets/images/niyogniyog1.jpeg',
            'assets/images/niyogniyog2.jpeg',
            'assets/images/niyogniyog3.jpeg',
            'assets/images/niyogniyog4.jpeg',
          ],
          'local_name': 'Niyog-Niyog',
          'scientific_name': 'Ficus pseudopalma Blanco',
          'description':
              'Niyog-niyogan is an erect, glabrous, unbranched shrub growing to a height of 5 meters. Leaves are crowded at the end of the stems, spreading and short-petioled, oblanceolate with a cordate base and an acute apex. Blade is coriaceous and dark-green, coarsely toothed growing to more than 25 centimeters long. Fruit is ovoid, angular, up to 4 centimeters long, on short peduncles and crowded at the axils of the leaves. The leaves and fruits leave a pattern of scars on the trunk.',
          'family': 'Moraceae',
          'benifits':
              'Young shoots are edible. In the Bicol area, leaves are cooked in gata (coconut milk). Cooked on top of steaming rice, then garnished with calamansi (Ini-ensalada). Cooked as side dish (bini-berdura) or as egg dish (tinorta). (15)- Study has shown leaves lubi-lubi leaves as potential flavoring in the preparation of enriched lubi-lubi noodles. (see study below). (15) Folkloric - Leaf decoction used for the treatment of hypertension, diabetes, kidney stones, and high cholesterol.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/pagsahingin1.jpg',
          'image_paths': [
            'assets/images/pagsahingin1.jpg',
          ],
          'local_name': 'Pagsahingin',
          'scientific_name': 'Canarium asperum Benth.',
          'description':
              'Found in primary and secondary forests at low and medium altitudes of dry thickets to wet areas. Can also be found in open areas and savannas.',
          'family': 'Burseraceae',
          'benifits': '',
          'summary': '',
          'uses':
              'Use oleoresin to treat arthritis, rheumatism, boils, abscess, furuncles, burns, sores; the bark is used for fever and chills; as anti-lice; wood for light construction such as crates, furniture, joinery, toys, novelty items, musical instruments, pulp; resin known as Manila elemi is used to make paints, varnishes, perfumes, illuminant, for caulking boats and other uses.',
        },
        {
          'path': 'assets/images/palosapis1.png',
          'image_paths': [
            'assets/images/palosapis1.png',
            'assets/images/palosapis2.png',
            'assets/images/palosapis3.png',
          ],
          'local_name': 'Palosapis',
          'scientific_name': 'Anisoptera thurifera Blume',
          'description':
              'Anisoptera is a genus of plant in the family Dipterocarpaceae. Anisoptera derives from Greek anisos meaning "unequal" and pteron meaning "wing", referring to the unequal fruit calyx lobes. It contains ten species, eight of which are currently listed on the IUCN red list, four as critically endangered and four as endangered. A 1990 study identifed three Philippine anisoptera species: Anisoptera costata, A. aurea (previously A. mindanensis), and A. thurifera. ',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/paho1.png',
          'image_paths': [
            'assets/images/paho1.png',
            'assets/images/paho2.jpg',
            'assets/images/paho3.jpg',
          ],
          'local_name': 'Paho',
          'scientific_name': 'Mangifera philippinensis Mukh.',
          'description':
              'Paho is much hardier than mango as common pests like leafhoppers, tip bores and seed bores do not affect the fruit. ',
          'family': 'Anacardiaceae',
          'benifits':
              'Studies have suggested antioxidant and antibacterial properties.Fruits are eaten fresh, ripe or unripe, pickled or used in salads.- Fruit often eaten unripe, as condiment, appetizer, or salad  ingredient. Ripe fruts used to prepare marmalade.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/pusopuso1.jpeg',
          'image_paths': [
            'assets/images/pusopuso1.jpeg',
            'assets/images/pusopuso2.jpg',
          ],
          'local_name': 'Puso-puso',
          'scientific_name': 'Neolitsea vidalii Merr.',
          'description':
              'Puso-puso is a small tree reaching a height of 10 to 15 meters. Younger parts are usually more or less softly hairy. Leaves are elliptical to oblong-elliptical, 9 to 20 centimeters long, broadly pointed at the base and tapering to a fine, pointed tip. Flowers are small and yellowish, crowded in umbels in the axis of the upper leaves. Fruits are rounded, about 8 millimeters in diameter.',
          'family': 'Lauraceae',
          'benifits':
              'Is included in the list of medicinal plants. Here, the pounded bark is also applied to wounds and bruises. In Bangladesh, the boiled leaves is used to cure diarrhea, while in India, the bark is pounded also and then applied to wounds.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/putat1.jpeg',
          'image_paths': [
            'assets/images/putat1.jpeg',
            'assets/images/putat2.jpg',
            'assets/images/putat3.jpeg',
            'assets/images/putat4.jpeg',
            'assets/images/putat.png',
          ],
          'local_name': 'Putat',
          'scientific_name': 'Barringtonia racemosa Blume ex DC',
          'description':
              'Putat is a smooth, small tree, growing to a height of 10 meters. Branches have prominent leaf-scars. Leaves occur at the ends of the branches, subsessile, oblong-ovate, 10 to 30 centimeters long, pointed at both ends, toothed at the margins. Flowers are white or pink, borne on terminal racemes or on drooping races from axils of fallen leaves, 20 to 60 centimeters long. Calyx encloses the bud, later splitting irregularly into 2 or 3 ovate, concave segments. Petals are oblong-ovate to lanceolate, 2 to 2.5 centimeters long, slightly united at the base. Stamens are very numerous, 3 to 4 centimeters long. Fruit is ovoid to oblong-ovoid, 5 to 6 centimeters long, somewhat 4-angled, crowned by a persistent calyx. Leathery pericarp of the fruit is green or purplish in color. Barringtonia racemosa, also known as Common Putat, has pendulous inflorescence, up to 1m long. The flowers are night-blooming and have filamentous stamens that are white, pink or red. The bark and fruits are crushed and used as fish poisons as they contain toxic saponins.',
          'family': 'Lecythidaceae',
          'benifits':
              'Fruit used for asthma, coughs and diarrhea. - Seeds are used in colic and ophthalmia. - Bark and leaves are used for rat and snake bits, on boils and gastric ulcers. - Pulverized fruit used as snuff for hemicrania; combined with other remedies, applied for skin affections.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/redlauan1.jpg',
          'image_paths': [
            'assets/images/redlauan1.jpg',
            'assets/images/redlauan2.jpg',
            'assets/images/redlauan3.jpg',
          ],
          'local_name': 'Red Lauan',
          'scientific_name': 'Shorea negrosensis Foxw.',
          'description':
              'Red lauan is a large evergreen tree that can grow up to 50 metres tall. It has a prominently buttressed bole that can be branchless for 20 - 30 metres with a diameter of up to 200 cm. The wood is a valuable export timber in the Philippines. It can be grown to stabilize the soil and restore native woodland.The tree is becoming rare in the wild due to habitat loss and overexploitation - it has been classified as Critically Endangered in the IUCN Red List of Threatened Species(2010).',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/sasalit1.jpeg',
          'image_paths': [
            'assets/images/sasalit1.jpeg',
            'assets/images/sasalit2.jpeg',
            'assets/images/sasalit3.jpeg',
          ],
          'local_name': 'Sasalit',
          'scientific_name': 'Teijsmanniodendron ahernianum',
          'description':
              'Sasalit is a medium to large-sized tree that can reach heights of up to 30 meters (about 98 feet). The leaves are typically simple, alternate, and have a glossy green appearance. They are generally elliptical or lanceolate in shape with smooth margins. The tree produces small, inconspicuous flowers that are often greenish or cream-colored. These flowers may not be particularly showy. The fruits of Sasalit are typically small and may have a fleshy texture when ripe. They may contain seeds. Native to Southeast Asia, including the Philippines. It is often found in lowland and montane forests in tropical and subtropical regions. The plant is classified as Least Concern in the IUCN Red List of Threatened Species.',
          'family': 'Verbenaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/sukalpi1.jpg',
          'image_paths': [
            'assets/images/sukalpi1.jpg',
            'assets/images/sukalpi2.jpg',
            'assets/images/sukalpi3.jpg',
          ],
          'local_name': 'Sukalpi',
          'scientific_name': 'Dimorphocalyx denticulatus Merr.',
          'description':
              'Sukalpi is a tree native to Southeast Asia. It is a medium-sized evergreen tree with glossy, elliptical leaves and small, fragrant flowers. The bark is often smooth and grayish-brown.',
          'family': 'Euphorbiaceae',
          'benifits':
              'Some traditional medicinal practices may use parts of Dimorphocalyx denticulatus for treating certain ailments. However, specific uses would depend on regional traditional knowledge. Like many trees, it potentially contributes to carbon sequestration and helps maintain ecological balance.',
          'summary': '',
          'uses':
              'The wood of this tree may be utilized for various purposes, such as construction, carpentry, or as a source of fuel. Due to its attractive foliage and fragrant flowers, Dimorphocalyx denticulatus may be planted for ornamental purposes in parks and gardens. The tree could contribute to local biodiversity by providing habitat and food for various wildlife species. ',
        },
        {
          'path': 'assets/images/tagotoi1.jpg',
          'image_paths': [
            'assets/images/tagotoi1.jpg',
            'assets/images/tagotoi2.jpg',
          ],
          'local_name': 'Tagotoi',
          'scientific_name': 'Palaquium foxwothyi',
          'description':
              'Tagotoi is a medium-sized to tall tree that can reach heights of up to 30 meters. It has glossy, elliptical leaves and produces small, inconspicuous flowers. The tree is known for its valuable timber. The conservation status of Palaquium foxworthyi may vary, but many native tree species in the Philippines face conservation challenges due to deforestation and habitat loss.',
          'family': 'Sapotaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'In some regions, the timber from this tree is used for construction and woodworking. Additionally, various parts of the tree may have traditional uses in indigenous cultures. It is important to note that conservation efforts are ongoing in the Philippines to protect native tree species like Palaquium foxworthyi due to their ecological significance and cultural value. If you have specific questions or require more detailed information about this tree species, local conservation efforts, or its uses, you may want to reach out to local environmental organizations or botanical experts in the Philippines. This tree is endemic to the Philippines and is found in certain regions of the country, particularly in Luzon and Mindanao.',
        },
        {
          'path': 'assets/images/tamayuan.jpeg',
          'image_paths': [
            'assets/images/tamayuan.jpeg',
            'assets/images/tamayuan1.jpeg',
            'assets/images/tamayuan2.jpeg',
            'assets/images/tamayuan4.jpeg',
          ],
          'local_name': 'Tamayuan',
          'scientific_name': 'Strombosia philippinensis (Baill.) Rolfe',
          'description':
              'Tree 5-28 m; Branchlets slender, glabrous. Leaves subdistichous, ovate-oblong to oblong, rarely lanceolate, apex shortly subacutely acuminate, base cuneate to the petiole, thin-charta-ceous, smooth above, finely wrinkled above, green to brownish and rather dull in dry specimens, glabrous, hardly or not pellucid-punctulate, (6-) 8-12 (-16) by (3-) 4-6 (-7.5) cm; Flowers on axillary very short multibracteolate subglobular axes, 5-8 per cluster; Petals 5, linear-oblong, greenish-white, glabrous outside, hairy at apex inside, 2 by 0.5 mm. Stamens 5; Ovary superior, subglobose; Strombosia philippinensis is a shrub or a tree growing 5 - 28 metres tall. The bole can be up to 30cm in diameter. The tree is harvested from the wild for its wood, which is used locally.',
          'family': 'Olacaceae',
          'benifits': '',
          'summary': '',
          'uses':
              'The dull yellowish to pinkish wood is heavy. It is used for house building. The wood is used for fuel. The plant is used as an antidote for Lophopetalum poisoning. Timber heavy, dull yellowish to pinkish, used for house building.',
        },
        {
          'path': 'assets/images/tibig1.jpeg',
          'image_paths': [
            'assets/images/tibig1.jpeg',
            'assets/images/tibig2.jpeg',
            'assets/images/tibig3.jpeg',
            'assets/images/tibig4.jpeg',
          ],
          'local_name': 'Tibig/Malatibig',
          'scientific_name': 'Ficus nota/congesta',
          'description':
              'Tibig is an erect, spreading, dioecious perennial tree, growing to a height of 8-10 meters. Branchlets are hairy. Leaves oblong to elliptic-obovate, 15 to 35 centimeters long and 8 to 12 centimeters wide; soft and pubescent beneath, the margins irregular and distinctly toothed, the apex abruptly acute, and the base auriculate. Midrib of leaves is stout, with 7 to 9 pairs of ascending, curved nerves. Petiole is brown, tomentose, 3 to 5 centimeters long. Tubercles are mostly cauline, occasionally from larger branches, clustered, rebranched, rigid, 20 centimeters long, bracteate. Figs are subglobose, 2 to 3.5 centimeters in diameter, glabrous, fleshy, pedunculate, green, becoming yellowish-white at the base, the umbilical scales exerted. Peduncle is acute, 2 centimeters long, with three bracts.',
          'family': 'Moraceae',
          'benifits':
              'Edibility - Ripe fruits are edible but rather tasteless; usually eaten with sugar.- Young leaves eaten as vegetable. Folkloric - Water extracted from standing tree drunk three times daily for fever.- Extracted water applied to relieve muscle pain.- Decoction of roots and bark used for urinary tract inflections, hypertension, and diabetes.- Water from cut branches used for urinary infections.- The Mansaka tribe of the Compostela Valley used a bark decoction to treat asthma, cough, and other respiratory conditions. The Ayta people of Porac, Pampanga use the stem of the plant species as repellent against hematophagous insects. Used for toothache and stomachache. Other - Wood: Used as firewood or charcoal.',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/tindalo1.jpeg',
          'image_paths': [
            'assets/images/tindalo1.jpg',
            'assets/images/tindalo2.png',
            'assets/images/tindalo3.jpeg',
            'assets/images/tindalo4.jpeg',
          ],
          'local_name': 'Tindalo',
          'scientific_name': '',
          'description': '',
          'family': '',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/tugbak1.jpg',
          'image_paths': [
            'assets/images/tugbak1.jpg',
            'assets/images/tugbak2.jpg',
            'assets/images/tugbak3.jpg',
          ],
          'local_name': 'Tugbak',
          'scientific_name': 'Stremonurus gitingensis elm.',
          'description':
              'The name of a plant defined with Alpinia elegans in various botanical sources. This page contains potential references in Ayurveda, modern medicine, and other folk traditions or local practices It has the synonym Hellenia gracilis (Blanco) Hausskn. (among others).',
          'family': 'Icacinaceae',
          'benifits':
              'Tumaneng and Castillo found that the chrondroprotective activity of Tagbak leaf extracts “is attributed to its ability to inhibit reactive oxygen species, while [maintaining] the antioxidant enzymes.” This leads to “the suppression of pro-inflammatory cytokines and matrix degrading enzymes due to the presence of putative compounds, specifically polyphenols and flavonoids.”',
          'summary': '',
          'uses':
              'Fruit rind is edible, a little woody in texture. Decoction of rhizomes used for hemoptysis. Pounded leaves, mixed with a little salt rubbed on paralyzed extremities. Juice from macerated young stems used for urticaria. Reported use for musculoskeletal diseases in the Surigao del Sur mountain range. Used for musculoskeletal diseases, migraines, stomachaches, and as anti-relapse treatment for women. ',
        },
        {
          'path': 'assets/images/whitelauan1.jpg',
          'image_paths': [
            'assets/images/whitelauan1.jpg',
            'assets/images/whitelauan2.jpg',
            'assets/images/whitelauan3.png',
          ],
          'local_name': 'White lauan',
          'scientific_name': 'Shorea contorta',
          'description':
              'The white lauan belongs to the dipterocarp family, a group of important timber trees that dominate the lowland rainforests of Asia. The white lauan has brown to nearly black bark, although it can look grey when exposed to bright sunlight. The upper part of the trunk may have distinct longitudinal ridges. The leaves of the white lauan have a thin, leathery texture and can measure up to 29 centimetres long and 11 centimetres wide . Dipterocarpplants have fairly large and showy flowers, to attract insects, and the fruit is a single-seeded nut enclosed within a winged case .',
          'family': 'Dipterocarpaceae',
          'benifits': '',
          'summary': '',
          'uses': '',
        },
        {
          'path': 'assets/images/yakalgisok1.jpg',
          'image_paths': [
            'assets/images/yakalgisok1.jpg',
            'assets/images/yakalgisok2.jpg',
            'assets/images/yakalgisok3.jpg',
          ],
          'local_name': 'Yakal gisok',
          'scientific_name': 'Shorea gisok',
          'description':
              'Yakal gisok also known as Gisok or Philippine Mahogany, is native to Southeast Asia. It belongs to the Dipterocarpaceae family and is known for its durable hardwood. Shorea gisok trees typically reach heights of 30 to 40 meters. They have straight trunks with a grayish-brown bark. The leaves are glossy and elliptical in shape. Due to the high demand for its timber, some species of Shorea, including Shorea gisok, face challenges related to deforestation and conservation. Sustainable forestry practices are essential to ensure the continued availability of this valuable hardwood.',
          'family': 'Dipterocarpaceae',
          'benifits':
              'The wood of Shorea gisok is highly valued for its strength and durability. It is resistant to decay, making it suitable for various construction purposes. The timber is also used in boat building and for making furniture.',
          'summary': '',
          'uses':
              'Common applications of Shorea gisok wood include crafting furniture, flooring, and outdoor structures. Its resistance to decay makes it ideal for use in marine environments, such as boat construction. Additionally, the trees resin is utilized in traditional medicine in some regions.',
        },
      ];

      for (var tracer in tree_datas) {
        final Uint8List tracerImageBytes =
            await loadImageAsUint8List(tracer['path']);

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
            favourite: 0);

        int newTreeId = await dbHelper.insertDBTracerData(newTracer);

        print("============newTreeId========");
        print(newTreeId);

        for (var tracerImgPath in tracer['image_paths']) {
          final fav =
              FavouriteModel(tracerId: newTreeId, imagePath: tracerImgPath);

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
    return prefs.getBool('is_seed') ??
        false; // Use a default value if the flag is not set.
  }

  Future<void> updateFlagInTempStorage(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_seed', newValue);
  }

  Future<List<Map>> getImagesFromTracer() async {
    final db = await database;
    List<Map> tracerImages = await db.rawQuery(
        'SELECT id, imageBlob, imagePath, local_name, scientific_name FROM tracer');

    return tracerImages;
  }
}
