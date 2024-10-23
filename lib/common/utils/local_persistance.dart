import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalPersistance {
  static const String _currentUserKey = "currentUser";
  static const String _currentFlowerpotId = "currentFlowerpotId";
  static const String _currentPlantTypeId = "currentPlantTypeId";

  Future<void> setUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_currentUserKey, jsonEncode(user));  // Puedes usar jsonEncode para convertir a JSON string
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  Future<void> setFlowerpot(int flowerpot) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_currentFlowerpotId, flowerpot);
  }

  Future<int?> getFlowerpot() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentFlowerpotId);
  }

  Future<void> setPlantType(int plantType) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_currentPlantTypeId, plantType);
  }

  Future<int?> getPlantType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentPlantTypeId);
  }

  Future<void> finishFlowerpotAssignment() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_currentFlowerpotId);
    prefs.remove(_currentPlantTypeId);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_currentUserKey);
    prefs.remove(_currentFlowerpotId);
    prefs.remove(_currentPlantTypeId);
  }
}