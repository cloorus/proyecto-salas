import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'core/services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquear orientación a portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Inicializar API Client con SharedPreferences
  await ApiClient.instance.initialize(sharedPreferences);

  runApp(
    ProviderScope(
      overrides: [
        // Override con la instancia inicializada
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const BGniusVitaApp(),
    ),
  );
}
