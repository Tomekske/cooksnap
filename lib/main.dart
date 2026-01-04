import 'package:cooksnap/presentation/pages/home_page.dart';
import 'package:cooksnap/presentation/pages/new_recipe_page.dart';
import 'package:cooksnap/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import our layers;
import 'core/core.dart';
import 'data/repositories/supabase_repository.dart';
import 'data/services/storage_service.dart';
import 'logic/cubits/cubits.dart';
import 'logic/cubits/recipe/recipe_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Config.load();

  // Initialize dependencies
  final remoteRepo = SupabaseRepository();
  final service = StorageService(remoteRepo);

  runApp(CooksnapApp(storageService: service));
}

class CooksnapApp extends StatelessWidget {
  final StorageService _storageService;

  const CooksnapApp({super.key, required StorageService storageService})
    : _storageService = storageService;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) => RecipeCubit(_storageService)..loadRecipes(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Cooksnap',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.teal,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,

            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage(),
              '/settings': (context) => const SettingsPage(),
              '/newRecipe': (context) => const NewRecipePage(),
            },
          );
        },
      ),
    );
  }
}
