class CategoryModel {
  final int id;
  final String name;
  final String iconName;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        name: json['name'],
        iconName: json['iconName'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconName': iconName,
      };
}
