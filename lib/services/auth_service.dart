import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// User model for storing user information
class UserModel {
  final String odId;  // รหัสประจำตัว (เลขประจำตัวทหาร หรือ ID อื่นๆ)
  final String fullName;
  final String rank;  // ยศ
  final String unit;  // หน่วย
  final String position;  // ตำแหน่ง
  final DateTime? birthDate;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String avatarType;  // 'military', 'shield', 'radio', 'signal'

  UserModel({
    required this.odId,
    required this.fullName,
    required this.rank,
    required this.unit,
    required this.position,
    this.birthDate,
    this.phoneNumber,
    required this.createdAt,
    required this.lastLogin,
    this.avatarType = 'military',
  });

  Map<String, dynamic> toJson() => {
    'odId': odId,
    'fullName': fullName,
    'rank': rank,
    'unit': unit,
    'position': position,
    'birthDate': birthDate?.toIso8601String(),
    'phoneNumber': phoneNumber,
    'createdAt': createdAt.toIso8601String(),
    'lastLogin': lastLogin.toIso8601String(),
    'avatarType': avatarType,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    odId: json['odId'] ?? '',
    fullName: json['fullName'] ?? '',
    rank: json['rank'] ?? '',
    unit: json['unit'] ?? '',
    position: json['position'] ?? '',
    birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
    phoneNumber: json['phoneNumber'],
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toIso8601String()),
    avatarType: json['avatarType'] ?? 'military',
  );

  UserModel copyWith({
    String? odId,
    String? fullName,
    String? rank,
    String? unit,
    String? position,
    DateTime? birthDate,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? lastLogin,
    String? avatarType,
  }) {
    return UserModel(
      odId: odId ?? this.odId,
      fullName: fullName ?? this.fullName,
      rank: rank ?? this.rank,
      unit: unit ?? this.unit,
      position: position ?? this.position,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      avatarType: avatarType ?? this.avatarType,
    );
  }
}

/// Authentication Service for user management
class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _pinKey = 'user_pin';
  static const String _useBiometricKey = 'use_biometric';
  static const String _loginHistoryKey = 'login_history';

  static SharedPreferences? _prefs;
  static UserModel? _currentUser;

  /// Initialize the service
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCurrentUser();
  }

  /// Load current user from storage
  static Future<void> _loadCurrentUser() async {
    if (_prefs == null) await init();
    final userJson = _prefs!.getString(_userKey);
    if (userJson != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userJson));
    }
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return _prefs?.getBool(_isLoggedInKey) ?? false;
  }

  /// Get current user
  static UserModel? getCurrentUser() {
    return _currentUser;
  }

  /// Register new user
  static Future<bool> register({
    required String odId,
    required String fullName,
    required String rank,
    required String unit,
    required String position,
    DateTime? birthDate,
    String? phoneNumber,
    required String pin,
  }) async {
    if (_prefs == null) await init();

    // Create new user
    final user = UserModel(
      odId: odId,
      fullName: fullName,
      rank: rank,
      unit: unit,
      position: position,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    // Save user data
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
    await _prefs!.setString(_pinKey, pin);
    await _prefs!.setBool(_isLoggedInKey, true);

    _currentUser = user;

    // Log the registration
    await _addLoginHistory('register');

    return true;
  }

  /// Login with PIN
  static Future<bool> login(String odId, String pin) async {
    if (_prefs == null) await init();

    final storedPin = _prefs!.getString(_pinKey);
    final userJson = _prefs!.getString(_userKey);

    if (userJson == null) return false;

    final user = UserModel.fromJson(jsonDecode(userJson));

    // Check ID and PIN
    if (user.odId == odId && storedPin == pin) {
      // Update last login
      final updatedUser = user.copyWith(lastLogin: DateTime.now());
      await _prefs!.setString(_userKey, jsonEncode(updatedUser.toJson()));
      await _prefs!.setBool(_isLoggedInKey, true);
      _currentUser = updatedUser;

      await _addLoginHistory('login');
      return true;
    }

    return false;
  }

  /// Quick login (PIN only for returning users)
  static Future<bool> quickLogin(String pin) async {
    if (_prefs == null) await init();

    final storedPin = _prefs!.getString(_pinKey);
    if (storedPin == pin) {
      await _prefs!.setBool(_isLoggedInKey, true);
      await _loadCurrentUser();

      // Update last login
      if (_currentUser != null) {
        final updatedUser = _currentUser!.copyWith(lastLogin: DateTime.now());
        await _prefs!.setString(_userKey, jsonEncode(updatedUser.toJson()));
        _currentUser = updatedUser;
      }

      await _addLoginHistory('quick_login');
      return true;
    }
    return false;
  }

  /// Logout
  static Future<void> logout() async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_isLoggedInKey, false);
    await _addLoginHistory('logout');
  }

  /// Check if user exists (for showing login vs register)
  static bool hasExistingUser() {
    return _prefs?.getString(_userKey) != null;
  }

  /// Update user profile
  static Future<bool> updateProfile({
    String? fullName,
    String? rank,
    String? unit,
    String? position,
    DateTime? birthDate,
    String? phoneNumber,
    String? avatarType,
  }) async {
    if (_prefs == null || _currentUser == null) return false;

    final updatedUser = _currentUser!.copyWith(
      fullName: fullName,
      rank: rank,
      unit: unit,
      position: position,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      avatarType: avatarType,
    );

    await _prefs!.setString(_userKey, jsonEncode(updatedUser.toJson()));
    _currentUser = updatedUser;
    return true;
  }

  /// Change PIN
  static Future<bool> changePin(String oldPin, String newPin) async {
    if (_prefs == null) return false;

    final storedPin = _prefs!.getString(_pinKey);
    if (storedPin == oldPin) {
      await _prefs!.setString(_pinKey, newPin);
      return true;
    }
    return false;
  }

  /// Set biometric preference
  static Future<void> setBiometric(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_useBiometricKey, enabled);
  }

  /// Get biometric preference
  static bool useBiometric() {
    return _prefs?.getBool(_useBiometricKey) ?? false;
  }

  /// Add login history entry
  static Future<void> _addLoginHistory(String action) async {
    if (_prefs == null) return;

    final history = _prefs!.getStringList(_loginHistoryKey) ?? [];
    final entry = '${DateTime.now().toIso8601String()}|$action';
    history.add(entry);

    // Keep only last 50 entries
    if (history.length > 50) {
      history.removeRange(0, history.length - 50);
    }

    await _prefs!.setStringList(_loginHistoryKey, history);
  }

  /// Get login history
  static List<Map<String, String>> getLoginHistory() {
    final history = _prefs?.getStringList(_loginHistoryKey) ?? [];
    return history.map((entry) {
      final parts = entry.split('|');
      return {
        'timestamp': parts[0],
        'action': parts.length > 1 ? parts[1] : 'unknown',
      };
    }).toList().reversed.toList();
  }

  /// Delete account and all data
  static Future<void> deleteAccount() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_userKey);
    await _prefs!.remove(_pinKey);
    await _prefs!.remove(_isLoggedInKey);
    await _prefs!.remove(_useBiometricKey);
    await _prefs!.remove(_loginHistoryKey);
    _currentUser = null;
  }

  /// Get display name with rank
  static String getDisplayName() {
    if (_currentUser == null) return 'ผู้ใช้งาน';
    return '${_currentUser!.rank} ${_currentUser!.fullName}';
  }

  /// Get short display name
  static String getShortName() {
    if (_currentUser == null) return 'ผู้ใช้';
    final names = _currentUser!.fullName.split(' ');
    return names.isNotEmpty ? names[0] : _currentUser!.fullName;
  }
}

/// List of Thai military ranks
class MilitaryRanks {
  static const List<String> enlisted = [
    'พลทหาร',
    'สิบตรี',
    'สิบโท',
    'สิบเอก',
    'จ่าสิบตรี',
    'จ่าสิบโท',
    'จ่าสิบเอก',
  ];

  static const List<String> officers = [
    'ร้อยตรี',
    'ร้อยโท',
    'ร้อยเอก',
    'พันตรี',
    'พันโท',
    'พันเอก',
    'พลตรี',
    'พลโท',
    'พลเอก',
  ];

  static const List<String> civilian = [
    'นาย',
    'นาง',
    'นางสาว',
  ];

  static List<String> get all => [...enlisted, ...officers, ...civilian];
}

/// List of Signal Corps units (เหล่าสื่อสาร)
class MilitaryUnits {
  // ==========================================
  // กรมการสื่อสารทหารบก และหน่วยขึ้นตรง
  // ==========================================
  static const List<String> signalDepartment = [
    'สส. (กรมการสื่อสารทหารบก)',
    'ส.๑ (กรมทหารสื่อสารที่ ๑)',
  ];

  // ==========================================
  // กองพันทหารสื่อสาร - ขึ้นตรง ส.๑
  // ==========================================
  static const List<String> signalBattalionsS1 = [
    'ส.พัน ๑๐๑',
    'ส.พัน ๑๐๒',
  ];

  // ==========================================
  // กองพันทหารสื่อสาร - กองทัพภาค
  // ==========================================
  static const List<String> signalBattalionsRegion = [
    'ส.พัน ๒๑ (ทภ.๑)',
    'ส.พัน ๒๒ (ทภ.๒)',
    'ส.พัน ๒๓ (ทภ.๓)',
    'ส.พัน ๒๔ (ทภ.๔)',
  ];

  // ==========================================
  // กองพันทหารสื่อสาร - กองพลทหารราบ
  // ==========================================
  static const List<String> signalBattalionsDivision = [
    'ส.พัน ๑ (พล.ร.๑)',
    'ส.พัน ๒ (พล.ร.๒ รอ.)',
    'ส.พัน ๓ (พล.ร.๓)',
    'ส.พัน ๔ (พล.ร.๔)',
    'ส.พัน ๕ (พล.ร.๕)',
    'ส.พัน ๖ (พล.ร.๖)',
    'ส.พัน ๗ (พล.ร.๗)',
    'ส.พัน ๙ (พล.ร.๙)',
    'ส.พัน ๑๕ (พล.ร.๑๕)',
  ];

  // ==========================================
  // กองพันทหารสื่อสาร - กองพลพิเศษ
  // ==========================================
  static const List<String> signalBattalionsSpecial = [
    'ส.พัน ๑๑ (พล.ม.๑)',
    'ส.พัน ๑๒ (พล.ม.๒ รอ.)',
    'ส.พัน ๑๓ (พล.ม.๓)',
    'ส.พัน ๑๔ (พล.ปตอ.)',
    'ส.พัน ๑๐ (พล.ป.)',
    'ส.พัน ๑๖ (นปอ.)',
  ];

  // ==========================================
  // หน่วยอื่น
  // ==========================================
  static const List<String> others = [
    'บก.ทบ.',
    'ยก.ทบ.',
    'กบ.ทบ.',
    'ศสส.',
    'หน่วยอื่น',
  ];

  /// All units combined for dropdown
  static List<String> get units => [
    ...signalDepartment,
    ...signalBattalionsS1,
    ...signalBattalionsRegion,
    ...signalBattalionsDivision,
    ...signalBattalionsSpecial,
    ...others,
  ];

  /// Get unit category
  static String getCategory(String unit) {
    if (signalDepartment.contains(unit)) return 'กรมการสื่อสารทหารบก';
    if (signalBattalionsS1.contains(unit)) return 'กองพันทหารสื่อสาร (ส.๑)';
    if (signalBattalionsRegion.contains(unit)) return 'กองพันทหารสื่อสาร (ทภ.)';
    if (signalBattalionsDivision.contains(unit)) return 'กองพันทหารสื่อสาร (พล.ร.)';
    if (signalBattalionsSpecial.contains(unit)) return 'กองพันทหารสื่อสาร (หน่วยพิเศษ)';
    return 'อื่นๆ';
  }
}
