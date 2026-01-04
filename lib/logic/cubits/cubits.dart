import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/recipe.dart';
import '../../data/repositories/recipe_repository.dart';

// --- Theme Cubit ---
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme(bool isDark) {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

// --- Recipe State ---
abstract class RecipeState extends Equatable {
  const RecipeState();
  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;
  const RecipeLoaded(this.recipes);
  @override
  List<Object?> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;
  const RecipeError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Recipe Cubit ---
class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _repository;

  RecipeCubit(this._repository) : super(RecipeInitial());

  Future<void> loadRecipes() async {
    try {
      emit(RecipeLoading());
      final recipes = await _repository.getRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Failed to load recipes: $e"));
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _repository.addRecipe(recipe);
      loadRecipes(); // Reload to update list
    } catch (e) {
      emit(RecipeError("Failed to add recipe"));
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _repository.deleteRecipe(id);
      loadRecipes();
    } catch (e) {
      emit(RecipeError("Failed to delete recipe"));
    }
  }
}
