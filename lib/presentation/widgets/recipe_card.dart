import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/enums/recipe_category.dart';
import '../../data/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              width: double.infinity,
              child: recipe.coverUrl != null && recipe.coverUrl!.isNotEmpty
                  ? (Uri.tryParse(recipe.coverUrl!)?.isAbsolute == true
                        ? Image.network(
                            recipe.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Center(child: Icon(Icons.broken_image)),
                            loadingBuilder: (c, child, progress) =>
                                progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          )
                        : Image.file(
                            File(recipe.coverUrl!),
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Center(child: Icon(Icons.broken_image)),
                          ))
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.no_photography,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        recipe.cookTime,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    RecipeCategory.fromValue(recipe.category).label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
