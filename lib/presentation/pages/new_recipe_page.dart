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

  final Color _primaryColor = const Color(0xFF109E88);
  final Color _lightGreen = const Color(0xFFE0F2F1);

  final _titleController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _tagController = TextEditingController();

  String _category = "Main Dish";
  final List<String> _tags = [];

  final List<String> _ingredients = [];
  final List<Direction> _directions = [];

  void _addTag(String val) {
    if (val.isNotEmpty && !_tags.contains(val)) {
      setState(() {
        _tags.add(val);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _lightGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Want a head start?",
                      style: TextStyle(
                        color: Color(0xFF00695C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.auto_awesome, size: 16),
                      label: const Text("AI Generate"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("RECIPE NAME"),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration("e.g. Mom's Spaghetti"),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("DURATION (MIN)"),
                              TextFormField(
                                controller: _cookTimeController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("30").copyWith(
                                  suffixIcon: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_drop_up, size: 18),
                                      Icon(Icons.arrow_drop_down, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("SERVINGS"),
                              TextFormField(
                                controller: _servingsController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration("2"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("IMAGE URL"),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: _inputDecoration("https://..."),
                    ),
                    const SizedBox(height: 16),

                    // Category
                    _buildLabel("CATEGORY"),
                    DropdownButtonFormField<String>(
                      value: _category,
                      decoration: _inputDecoration("Select Category"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          [
                                "Appetizer",
                                "Breakfast",
                                "Dessert",
                                "Drinks",
                                "Main Dish",
                                "Side Dish",
                                "Snacks",
                                "Other",
                              ]
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => _category = v!),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("TAGS"),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: _inputDecoration(
                              "Add tag (e.g. Healthy)...",
                            ),
                            onFieldSubmitted: _addTag,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => _addTag(_tagController.text),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),

                    if (_tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                backgroundColor: _lightGreen,
                                labelStyle: TextStyle(color: _primaryColor),
                                deleteIcon: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: _primaryColor,
                                ),
                                onDeleted: () => _removeTag(tag),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                side: BorderSide.none,
                              ),
                            )
                            .toList(),
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "No tags added. Auto-tags will be generated on save.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Steps",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            _buildStepButton(
                              Icons.auto_fix_high,
                              "Polish",
                              Colors.purple.shade50,
                              Colors.purple,
                            ),
                            const SizedBox(width: 8),
                            _buildStepButton(
                              Icons.add,
                              "Main",
                              _lightGreen,
                              _primaryColor,
                            ),
                            const SizedBox(width: 8),
                            _buildStepButton(
                              Icons.add,
                              "Sub",
                              Colors.grey.shade100,
                              Colors.grey.shade700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Save Recipe",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildStepButton(IconData icon, String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
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
        tags: _tags,
        // Since image URL and Directions were not in original model constructor in the provided snippet,
        // we might need to adjust or they might be optional.
        // Assuming the Recipe model can take ingredients from existing lists or new structure.
        ingredients: _ingredients,
        directions: _directions,
      );

      context.read<RecipeCubit>().addRecipe(recipe);
      Navigator.pop(context);
    }
  }
}
