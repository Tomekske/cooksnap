import 'package:cooksnap/logic/cubits/recipe/recipe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/recipe.dart';
import '../../../data/services/storage_service.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final StorageService _storageService;

  RecipeCubit(this._storageService) : super(RecipeInitial());

  Future<void> loadRecipes() async {
    try {
      emit(RecipeLoading());
      final recipes = await _storageService.getRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Failed to load recipes: $e"));
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    // TODO
  }

  Future<void> deleteRecipe(int id) async {
    // TODO
  }
}
