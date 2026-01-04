import 'package:cooksnap/data/enums/recipe_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/instruction.dart';
import '../../data/models/recipe.dart';
import '../../logic/cubits/recipe/recipe_cubit.dart';

class StepField {
  TextEditingController controller = TextEditingController();
  List<StepField> subSteps = [];

  StepField();

  void dispose() {
    controller.dispose();
    for (final sub in subSteps) {
      sub.dispose();
    }
  }
}

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

  final List<String> _tags = [];

  final List<StepField> _stepFields = [];

  @override
  void dispose() {
    _titleController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _imageUrlController.dispose();
    _tagController.dispose();

    for (final step in _stepFields) {
      step.dispose();
    }

    super.dispose();
  }

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

  void _addMainStep() {
    setState(() {
      _stepFields.add(StepField());
    });
  }

  void _addSubStepToLast() {
    if (_stepFields.isNotEmpty) {
      setState(() {
        _stepFields.last.subSteps.add(StepField());
      });
    } else {
      _addMainStep();
    }
  }

  void _addSubStepTo(StepField parent) {
    setState(() {
      parent.subSteps.add(StepField());
    });
  }

  void _removeStep(StepField step) {
    setState(() {
      _stepFields.remove(step);
    });
  }

  void _removeSubStep(StepField parent, StepField child) {
    setState(() {
      parent.subSteps.remove(child);
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
                  border: Border.all(
                    color: _primaryColor.withValues(alpha: 0.3),
                  ),
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
                      color: Colors.black.withValues(alpha: 0.05),
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
                                decoration: _inputDecoration("30"),
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
                    _buildLabel("TAGS"),
                    TextFormField(
                      controller: _tagController,
                      decoration: _inputDecoration("Add tag..."),
                      onFieldSubmitted: _addTag,
                    ),
                    if (_tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8,
                          children: _tags
                              .map(
                                (t) => Chip(
                                  label: Text(t),
                                  onDeleted: () => _removeTag(t),
                                ),
                              )
                              .toList(),
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
                              icon: Icons.auto_fix_high,
                              label: "Polish",
                              bg: Colors.purple.shade50,
                              fg: Colors.purple,
                              onTap: () {}, // Polish logic
                            ),
                            const SizedBox(width: 8),
                            _buildStepButton(
                              icon: Icons.add,
                              label: "Main",
                              bg: _lightGreen,
                              fg: _primaryColor,
                              onTap: _addMainStep,
                            ),
                            const SizedBox(width: 8),
                            _buildStepButton(
                              icon: Icons.add,
                              label: "Sub",
                              bg: Colors.grey.shade100,
                              fg: Colors.grey.shade700,
                              onTap: _addSubStepToLast,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_stepFields.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No steps added yet.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stepFields.length,
                        itemBuilder: (context, index) {
                          return _buildStepItem(_stepFields[index], index);
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
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

  Widget _buildStepItem(StepField step, int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: step.controller,
                maxLines: null,
                decoration: _inputDecoration("Main Step instruction..."),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                _buildIconButton(
                  Icons.delete_outline,
                  Colors.red.shade50,
                  Colors.red.shade300,
                  () => _removeStep(step),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () => _addSubStepTo(step),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Sec",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (step.subSteps.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 12.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey, width: 1)),
              ),
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                children: step.subSteps.map((subStep) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: subStep.controller,
                            decoration: _inputDecoration("Sub-step detail...")
                                .copyWith(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.black87,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            _buildIconButton(
                              Icons.delete_outline,
                              Colors.red.shade50,
                              Colors.red.shade300,
                              () => _removeSubStep(step, subStep),
                            ),
                            const SizedBox(height: 4),
                            // Sub-steps usually don't have their own sub-steps in this UI,
                            // but we keep spacing consistent
                            const SizedBox(height: 32),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    Color bg,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required String label,
    required Color bg,
    required Color fg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      final recipe = Recipe(
        title: _titleController.text,
        coverUrl: _imageUrlController.text.isEmpty
            ? null
            : _imageUrlController.text,
        cookTime: _cookTimeController.text,
        servings: int.tryParse(_servingsController.text) ?? 1,
        category: RecipeCategory.mainDish.value,
        tags: _tags,
        ingredients: [], // TODO: Add ingredients input UI
        instructions: _stepFields.map((stepField) {
          return Instruction(
            title: stepField.controller.text,
            steps: stepField.subSteps
                .map((sub) => sub.controller.text)
                .toList(),
          );
        }).toList(),
      );

      context.read<RecipeCubit>().addRecipe(recipe);
      Navigator.pop(context);
    }
  }
}
