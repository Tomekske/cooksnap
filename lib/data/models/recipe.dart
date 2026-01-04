import 'package:equatable/equatable.dart';

import 'instruction.dart';

class Recipe extends Equatable {
  final int? id;
  final String title;
  final String? coverUrl;
  final String cookTime;
  final int servings;
  final int category;
  final List<String> tags;
  final List<String> ingredients;
  final List<Instruction> instructions;

  const Recipe({
    this.id,
    required this.title,
    this.coverUrl,
    required this.cookTime,
    required this.servings,
    required this.category,
    required this.tags,
    required this.ingredients,
    required this.instructions,
  });

  Recipe copyWith({
    int? id,
    String? title,
    String? coverUrl,
    String? cookTime,
    int? servings,
    int? category,
    List<String>? tags,
    List<String>? ingredients,
    List<Instruction>? instructions,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int?,
      title: json['title'] ?? '',
      coverUrl: json['cover_url'],
      cookTime: json['cook_time'] ?? '',
      servings: json['servings'] ?? 1,
      category: (json['category'] is int) ? json['category'] : 11,
      tags: List<String>.from(json['tags'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => Instruction.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'cover_url': coverUrl,
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
    coverUrl,
    cookTime,
    servings,
    category,
    tags,
    ingredients,
    instructions,
  ];
}
