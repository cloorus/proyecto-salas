import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';

/// Aplicación principal BGnius VITA
class BGniusVitaApp extends StatelessWidget {
  const BGniusVitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BGnius',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Localizations
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),  // Español
        Locale('en'),  // English
      ],
      locale: const Locale('es'),  // Default locale
      
      routerConfig: appRouter,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // Allow user text scaling but cap it to avoid breaking layouts on mobile
        final cappedScale = mq.textScaler.scale(1.0).clamp(1.0, 1.15);
        return MediaQuery(
          data: mq.copyWith(textScaler: TextScaler.linear(cappedScale)),
          child: child!,
        );
      },
    );
  }
}
