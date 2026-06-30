class SmsProvider {
  int id;
  String name;
  bool selected;
  
  SmsProvider({required this.id, required this.name, required this.selected});
  
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  SmsProvider.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      name = map['name'],
      selected = true;
}
