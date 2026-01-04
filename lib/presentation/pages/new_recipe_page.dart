import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/recipe_model.dart';
import '../../logic/cubits/cubits.dart';

class NewRecipePage extends StatefulWidget {
  const NewRecipePage({super.key});

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  // State
  String _category = "Main Dish";
  final List<String> _ingredients = [];
  final List<Direction> _directions = [];

  // Helper to add ingredient
  void _addIngredient(String val) {
    if (val.isNotEmpty) setState(() => _ingredients.add(val));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Recipe"),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveRecipe),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cookTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Time (e.g. 30m)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _servingsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Servings',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: [
                "Appetizer",
                "Breakfast",
                "Dessert",
                "Drinks",
                "Main Dish",
                "Side Dish",
                "Snacks",
                "Other",
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 24),
            const Text(
              "Ingredients",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._ingredients.map(
              (e) => ListTile(
                dense: true,
                title: Text("• $e"),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => setState(() => _ingredients.remove(e)),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  _showInputDialog("Add Ingredient", _addIngredient),
              icon: const Icon(Icons.add),
              label: const Text("Add Ingredient"),
            ),
          ],
        ),
      ),
    );
  }

  void _showInputDialog(String title, Function(String) onAdd) {
    String tempVal = "";
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: TextField(onChanged: (v) => tempVal = v, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onAdd(tempVal);
              Navigator.pop(c);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        title: _titleController.text,
        cookTime: _cookTimeController.text,
        servings: int.tryParse(_servingsController.text) ?? 1,
        category: _category,
        tags: const [],
        ingredients: _ingredients,
        directions: const [],
      );

      context.read<RecipeCubit>().addRecipe(recipe);
      Navigator.pop(context);
    }
  }
}
