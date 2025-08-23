import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';
  
  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  UserModel? get currentUser => _currentUser;
  
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '{}';
      final users = <String, dynamic>{};
      
      if (usersJson.isNotEmpty && usersJson != '{}') {
        final decoded = jsonDecode(usersJson) as Map<String, dynamic>;
        users.addAll(decoded);
      }
      
      if (users.containsKey(email)) {
        final userData = Map<String, dynamic>.from(users[email]);
        if (userData['password'] == password) {
          final userModel = UserModel.fromJson(userData);
          final updatedUser = userModel.copyWith(lastLoginAt: DateTime.now());
          
          // Update user data with new login time
          users[email] = updatedUser.toJson();
          await prefs.setString(_usersKey, jsonEncode(users));
          
          // Set current user
          _currentUser = updatedUser;
          await prefs.setString(_userKey, jsonEncode(updatedUser.toJson()));
          _authStateController.add(_currentUser);
          
          return updatedUser;
        } else {
          throw 'パスワードが間違っています';
        }
      } else {
        throw 'メールアドレスが見つかりません';
      }
    } catch (e) {
      throw _getAuthException(e);
    }
  }

  Future<UserModel?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey) ?? '{}';
      final users = <String, dynamic>{};
      
      if (usersJson.isNotEmpty && usersJson != '{}') {
        final decoded = jsonDecode(usersJson) as Map<String, dynamic>;
        users.addAll(decoded);
      }
      
      if (users.containsKey(email)) {
        throw 'このメールアドレスは既に使用されています';
      }
      
      final userModel = UserModel(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      // Store password separately (in a real app, you would hash this)
      final userDataWithPassword = userModel.toJson();
      userDataWithPassword['password'] = password;
      
      users[email] = userDataWithPassword;
      await prefs.setString(_usersKey, jsonEncode(users));
      
      // Set current user
      _currentUser = userModel;
      await prefs.setString(_userKey, jsonEncode(userModel.toJson()));
      _authStateController.add(_currentUser);
      
      return userModel;
    } catch (e) {
      throw _getAuthException(e);
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _currentUser = null;
    _authStateController.add(null);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    // In a local storage implementation, we can't actually send emails
    // This would typically integrate with an email service
    throw 'パスワードリセット機能は現在利用できません';
  }

  Future<void> initialize() async {
    // Load current user from storage on app start
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(userData);
        _authStateController.add(_currentUser);
      } catch (e) {
        // If there's an error parsing user data, clear it
        await prefs.remove(_userKey);
      }
    }
  }

  void dispose() {
    _authStateController.close();
  }

  String _getAuthException(dynamic error) {
    if (error is String) {
      return error;
    }
    return '予期しないエラーが発生しました: ${error.toString()}';
  }
}