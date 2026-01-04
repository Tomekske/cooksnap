import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/instruction.dart';
import '../models/recipe.dart';

// Handles low-level DB connection
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  SupabaseClient get client => _client;

  SupabaseQueryBuilder get recipesTable => _client.from('recipes');
}

// --- Recipe Repository Interface ---
abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();
  Future<void> addRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
  Future<void> updateRecipe(Recipe recipe);
}

// --- Recipe Repository Implementation ---
class RecipeRepositoryImpl implements RecipeRepository {
  final SupabaseService _supabaseService;

  // TEMPORARY: In-memory storage for the prototype
  final List<Recipe> _mockStorage = [
    Recipe(
      id: '1',
      title: 'Spaghetti Carbonara',
      cookTime: '30 min',
      servings: 2,
      category: 'Main Dish',
      tags: ['Italian', 'Pasta'],
      ingredients: ['Spaghetti', 'Eggs', 'Pancetta', 'Parmesan'],
      instructions: [
        Instruction(title: 'Prep', steps: ['Boil water', 'Chop pancetta']),
        Instruction(
          title: 'Cook',
          steps: ['Cook pasta', 'Fry pancetta', 'Mix with eggs'],
        ),
      ],
      createdAt: DateTime.now(),
    ),
  ];

  RecipeRepositoryImpl(this._supabaseService);

  @override
  Future<List<Recipe>> getRecipes() async {
    // PROTOTYPE LOGIC: Return mock data first
    // When ready for Supabase:
    // final response = await _supabaseService.recipesTable.select().order('created_at');
    // return (response as List).map((e) => Recipe.fromJson(e)).toList();

    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    return _mockStorage;
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    // PROTOTYPE LOGIC:
    // When ready for Supabase:
    // await _supabaseService.recipesTable.insert(recipe.toJson());

    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate ID generation
    final newRecipe = recipe.copyWith(id: DateTime.now().toIso8601String());
    _mockStorage.add(newRecipe);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    // PROTOTYPE LOGIC:
    // await _supabaseService.recipesTable.delete().eq('id', id);

    _mockStorage.removeWhere((r) => r.id == id);
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    // PROTOTYPE LOGIC:
    // await _supabaseService.recipesTable.update(recipe.toJson()).eq('id', recipe.id);

    final index = _mockStorage.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _mockStorage[index] = recipe;
    }
  }
}
