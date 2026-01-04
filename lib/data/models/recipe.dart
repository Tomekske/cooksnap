import 'package:equatable/equatable.dart';

import 'instruction.dart';

class Recipe extends Equatable {
  final String? id;
  final String title;
  final String? pictureUrl;
  final String cookTime;
  final int servings;
  final String category;
  final List<String> tags;
  final List<String> ingredients;
  final List<Instruction> instructions;
  final DateTime? createdAt;

  const Recipe({
    this.id,
    required this.title,
    this.pictureUrl,
    required this.cookTime,
    required this.servings,
    required this.category,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    this.createdAt,
  });

  Recipe copyWith({
    String? id,
    String? title,
    String? pictureUrl,
    String? cookTime,
    int? servings,
    String? category,
    List<String>? tags,
    List<String>? ingredients,
    List<Instruction>? instructions,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as String?,
      title: json['title'] ?? '',
      pictureUrl: json['image_url'], // Mapping snake_case from DB
      cookTime: json['cook_time'] ?? '',
      servings: json['servings'] ?? 1,
      category: json['category'] ?? 'Other',
      tags: List<String>.from(json['tags'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => Instruction.fromJson(e))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image_url': pictureUrl,
      'cook_time': cookTime,
      'servings': servings,
      'category': category,
      'tags': tags,
      'ingredients': ingredients,
      'instructions': instructions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    pictureUrl,
    cookTime,
    servings,
    category,
    tags,
    ingredients,
    instructions,
  ];
}
