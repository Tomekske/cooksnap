import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/cubits.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooksnap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/newRecipe'),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipeLoaded) {
            if (state.recipes.isEmpty) {
              return const Center(child: Text("No recipes yet. Add one!"));
            }
            return ListView.builder(
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: recipe.pictureUrl != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(recipe.pictureUrl!),
                          )
                        : const CircleAvatar(child: Icon(Icons.restaurant)),
                    title: Text(recipe.title),
                    subtitle: Text("${recipe.category} • ${recipe.cookTime}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        context.read<RecipeCubit>().deleteRecipe(recipe.id!);
                      },
                    ),
                    onTap: () {
                      // TODO: Navigate to details
                    },
                  ),
                );
              },
            );
          } else if (state is RecipeError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
