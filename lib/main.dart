import 'package:cooksnap/presentation/pages/home_page.dart';
import 'package:cooksnap/presentation/pages/new_recipe_page.dart';
import 'package:cooksnap/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import our layers;
import 'data/repositories/recipe_repository.dart';
import 'logic/cubits/cubits.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- SUPABASE SETUP ---
  // Note: Even if you don't connect, Supabase.initialize needs url/anonKey to compile if you check them.
  // For the prototype 'Mock' mode, we can skip actual initialization or provide dummy strings.
  // Uncomment and fill these when ready to connect real data.
  /*
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  */

  final mockSupabaseClient = SupabaseClient(
    'https://mock.supabase.co',
    'mockKey',
  );

  final supabaseService = SupabaseService(mockSupabaseClient);
  final recipeRepository = RecipeRepositoryImpl(supabaseService);

  runApp(CooksnapApp(recipeRepository: recipeRepository));
}

class CooksnapApp extends StatelessWidget {
  final RecipeRepository recipeRepository;

  const CooksnapApp({super.key, required this.recipeRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(
          create: (context) => RecipeCubit(recipeRepository)..loadRecipes(),
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
