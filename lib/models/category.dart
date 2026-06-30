class Category {
  final int id;
  final String name;
  final bool isExpense;

  Category({required this.id, required this.name, required this.isExpense});
  Map<String, dynamic> toMap() {
    return {'name': name,'isExpense':isExpense?1:0};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      isExpense: (map['isExpense'] as int)==1?true:false
    );
  }
  Category getclone() {
    return Category(name: name,isExpense:  isExpense,id: id);
  }
  Category copyWith({
    int? id,
    String? name,
    bool? isExpense,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      isExpense: isExpense ?? this.isExpense,
    );
  }
}
