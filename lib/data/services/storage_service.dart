import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../repositories/supabase_repository.dart';

class StorageService {
  final SupabaseRepository _remoteRepo;

  StorageService(this._remoteRepo);

  /// Ensures the user is authenticated (anonymously) before making requests.
  Future<void> initialize() async {
    try {
      await _remoteRepo.initializeUser();
    } catch (e) {
      debugPrint('Failed to initialize Supabase user: $e');
      rethrow;
    }
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      return await _remoteRepo.getRecipes();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    // TODO
  }
}
