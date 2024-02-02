import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:habitual/l10n/string_hardcoded.dart';
import 'package:habitual/src/methods/auth/firebase_auth.dart';
import 'package:habitual/src/presentation/authentication_screen/view/sign_in_screen.dart';
import 'package:habitual/src/presentation/splash_screen/view/splash.dart';
import 'package:habitual/src/presentation/splash_screen/view/splash_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'l10n/l10n.dart';
import 'src/core/core_export.dart';
import 'src/routes/routes_export.dart';
import 'src/theme/theme_export.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) => Get.put(FirebaseAuthService()));
  if (kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyB-oWK9EpHZV2fPnhTE-7NqdiP_X-F7hQY",
        appId: "1:280384188382:web:e384382910c61e7a0b374f",
        messagingSenderId:  "280384188382",
        projectId: "water-atm-d9acd")
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        // AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      onGenerateTitle: (context) => 'My App'.hardcoded,
      theme: AppThemes().lightTheme,
      darkTheme: AppThemes().darkTheme,
      title: AppTitles.appTitle,
      home: SplashScreen(),
      navigatorKey: Get.key,
      getPages: AppPages.pages,
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: [
          const ResponsiveBreakpoint.resize(
            350,
            name: MOBILE,
          ),
          const ResponsiveBreakpoint.autoScale(
            600,
            name: TABLET,
            scaleFactor: 1.3,
          ),
          const ResponsiveBreakpoint.autoScale(
            800,
            name: DESKTOP,
          ),
          const ResponsiveBreakpoint.autoScale(
            1200,
            name: 'XL',
            scaleFactor: 1.4,
          ),
        ],
      ),
    );
  }
}
