import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing favorite units
class FavoritesService {
  static const String _favoritesKey = 'favorite_units';
  static FavoritesService? _instance;

  SharedPreferences? _prefs;
  List<String> _favoriteIds = [];

  FavoritesService._();

  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }

  /// Initialize the service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoriteIds = _prefs?.getStringList(_favoritesKey) ?? [];
  }

  Future<void> _saveFavorites() async {
    await _prefs?.setStringList(_favoritesKey, _favoriteIds);
  }

  /// Get all favorite unit IDs
  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  /// Get the count of favorites
  int get count => _favoriteIds.length;

  /// Check if a unit is favorited
  bool isFavorite(String unitId) {
    return _favoriteIds.contains(unitId);
  }

  /// Add a unit to favorites
  Future<void> addFavorite(String unitId) async {
    if (!_favoriteIds.contains(unitId)) {
      _favoriteIds.add(unitId);
      await _saveFavorites();
    }
  }

  /// Remove a unit from favorites
  Future<void> removeFavorite(String unitId) async {
    _favoriteIds.remove(unitId);
    await _saveFavorites();
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String unitId) async {
    if (isFavorite(unitId)) {
      await removeFavorite(unitId);
      return false;
    } else {
      await addFavorite(unitId);
      return true;
    }
  }

  /// Clear all favorites
  Future<void> clearAll() async {
    _favoriteIds.clear();
    await _saveFavorites();
  }

  /// Reorder favorites (for drag and drop)
  Future<void> reorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _favoriteIds.removeAt(oldIndex);
    _favoriteIds.insert(newIndex, item);
    await _saveFavorites();
  }
}
