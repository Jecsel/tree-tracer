class FavouriteModel {
  final int? id;
  final int tracerId;
  final String imagePath;

  FavouriteModel({
    this.id,
    required this.tracerId,
    required this.imagePath
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tracerId': tracerId,
      'imagePath': imagePath
    };
  }

  factory FavouriteModel.fromMap(Map<String, dynamic> map) {
    return FavouriteModel(
      id: map['id'],
      tracerId: map['tracerId'],
      imagePath: map['imagePath']
    );
  }
}
