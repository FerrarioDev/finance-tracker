class MyCategory {
  final int id;
  final String name;
  final CategoryType type;
  final String description;

  MyCategory({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
  });

  static CategoryType _categoryTypeFromString(String type) {
    switch (type) {
      case 'BUDGET':
        return CategoryType.BUDGET;
      case 'TRANSACTION':
        return CategoryType.TRANSACTION;
      default:
        throw Exception('Unknown CategoryType: $type');
    }
  }

  factory MyCategory.fromJson(Map<String, dynamic> json) {
    return MyCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      type: _categoryTypeFromString(
          json['type'] as String), // Convert the string to CategoryType
      description: json['description'] as String,
    );
  }

  static List<MyCategory> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MyCategory.fromJson(json)).toList();
  }
}

enum CategoryType { BUDGET, TRANSACTION }
