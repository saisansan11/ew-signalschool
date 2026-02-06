import 'package:shared_preferences/shared_preferences.dart';

/// Service for tracking recently viewed units
class RecentUnitsService {
  static const String _recentKey = 'recent_units';
  static const int _maxRecent = 10;
  static RecentUnitsService? _instance;

  SharedPreferences? _prefs;
  List<String> _recentIds = [];

  RecentUnitsService._();

  static RecentUnitsService get instance {
    _instance ??= RecentUnitsService._();
    return _instance!;
  }

  /// Initialize the service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _loadRecent();
  }

  void _loadRecent() {
    _recentIds = _prefs?.getStringList(_recentKey) ?? [];
  }

  Future<void> _saveRecent() async {
    await _prefs?.setStringList(_recentKey, _recentIds);
  }

  /// Get all recent unit IDs (most recent first)
  List<String> get recentIds => List.unmodifiable(_recentIds);

  /// Get the count of recent units
  int get count => _recentIds.length;

  /// Add a unit to recent history
  Future<void> addRecent(String unitId) async {
    // Remove if already exists (to move to top)
    _recentIds.remove(unitId);

    // Add to beginning
    _recentIds.insert(0, unitId);

    // Trim to max size
    if (_recentIds.length > _maxRecent) {
      _recentIds = _recentIds.sublist(0, _maxRecent);
    }

    await _saveRecent();
  }

  /// Remove a unit from recent history
  Future<void> removeRecent(String unitId) async {
    _recentIds.remove(unitId);
    await _saveRecent();
  }

  /// Clear all recent history
  Future<void> clearAll() async {
    _recentIds.clear();
    await _saveRecent();
  }

  /// Check if a unit is in recent history
  bool isRecent(String unitId) {
    return _recentIds.contains(unitId);
  }
}
