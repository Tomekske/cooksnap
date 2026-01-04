import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recipe.dart';

class SupabaseRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _recipesTable = 'cooksnap_recipes';

  Future<void> initializeUser() async {
    if (_client.auth.currentUser == null) {
      await _client.auth.signInAnonymously();
    }
  }

  Future<List<Recipe>> getRecipes() async {
    try {
      final List<dynamic> data = await _client
          .from(_recipesTable)
          .select()
          .order('title', ascending: false);

      return data.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading recipes: $e');
      rethrow;
    }
  }
}
