import 'dart:typed_data';

class TracerModel {
  final int? id;
  final Uint8List? imageBlob;
  String? imagePath;
  final String local_name;  
  final String scientific_name;
  final String description;
  final String summary;
  final String family;
  final String benifits;
  final String uses;
  final String trivia;
  int? favourite;

  TracerModel({
    this.id,
    this.imageBlob,
    this.imagePath,
    required this.local_name,
    required this.scientific_name,
    required this.description,
    required this.summary,
    required this.family,
    required this.benifits,
    required this.uses,
    required this.favourite,
    required this.trivia
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageBlob': imageBlob,
      'imagePath': imagePath,
      'local_name': local_name,
      'scientific_name': scientific_name,
      'description': description,
      'summary': summary,
      'family': family,
      'benifits': benifits,
      'uses': uses,
      'favourite': favourite,
      'trivia': trivia
    };
  }

  factory TracerModel.fromMap(Map<String, dynamic> map) {
    return TracerModel(
      id: map['id'],
      imageBlob: map['imageBlob'],
      imagePath: map['imagePath'],
      local_name: map['local_name'],
      scientific_name: map['scientific_name'],
      description: map['description'],
      summary: map['summary'],
      family: map['family'],
      benifits: map['benifits'],
      uses: map['uses'],
      favourite: map['favourite'],
      trivia: map['trivia']
    );
  }

  TracerModel copy({
    int? id,
    Uint8List? imageBlob,
    String? imagePath,
    String? local_name,
    String? scientific_name,
    String? description,
    String? summary,
    String? family,
    String? benifits,
    String? uses,
    int? favourite,
    String? trivia
  }) {
    return TracerModel(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      imagePath: imagePath ?? this.imagePath,
      local_name: local_name ?? this.local_name,
      scientific_name: scientific_name ?? this.scientific_name,
      description: description ?? this.description,
      summary: summary ?? this.summary,
      family: family ?? this.family,
      benifits: benifits ?? this.benifits,
      uses: uses ?? this.uses,
      favourite: favourite ?? this.favourite,
      trivia: trivia ?? this.trivia
    );
  }
}
