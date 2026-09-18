import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcoArApp());
}

class EcoArApp extends StatelessWidget {
  const EcoArApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final localeCtrl = LocaleController.instance;
        return MaterialApp.router(
          title: 'EcoAR Kerkennah',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: localeCtrl.locale,
          supportedLocales: const [
            Locale('fr'),
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: localeCtrl.textDirection,
              child: child ?? const SizedBox.shrink(),
            );
          },
          routerConfig: router,
        );
      },
    );
  }
}
