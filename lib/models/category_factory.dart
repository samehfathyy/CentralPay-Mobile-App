

import 'package:budgeta/models/category.dart'as model;

class CategoryFactory {
  static final Map<int, model.Category> _cache = {};

  static model.Category? getCategory(model.Category category) {
    return _cache.putIfAbsent(category.id, () => category);
  }
  static model.Category? getCategoryById(int id) {
    if(_cache.containsKey(id)==false){
      return null;
    }
    return _cache[id];
  }
  static void preload(List<model.Category> categories) {
    for (final c in categories) {
      _cache[c.id] = c;
    }
  }
}
