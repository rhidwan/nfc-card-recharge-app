import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:PureDrop/l10n/string_hardcoded.dart';
import 'package:PureDrop/src/methods/auth/firebase_auth.dart';
import 'package:PureDrop/src/presentation/authentication_screen/view/sign_in_screen.dart';
import 'package:PureDrop/src/presentation/bulk_recharge_screen/view/bulk_recharge.dart';
import 'package:PureDrop/src/presentation/card_details_screen/view/view_card_details.dart';
import 'package:PureDrop/src/presentation/splash_screen/view/splash.dart';
import 'package:PureDrop/src/presentation/splash_screen/view/splash_screen.dart';
import 'package:PureDrop/src/presentation/home_screen/view/homepage.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'l10n/l10n.dart';
import 'src/core/core_export.dart';
import 'src/routes/routes_export.dart';
import 'src/theme/theme_export.dart';

bool isNfcAvalible = false;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  isNfcAvalible = await NfcManager.instance.isAvailable();
  await Firebase.initializeApp().then((value) => Get.put(FirebaseAuthService()));
  if (kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
        apiKey: "AIzaSyB-oWK9EpHZV2fPnhTE-7NqdiP_X-F7hQY",
        appId: "1:280384188382:web:e384382910c61e7a0b374f",
        messagingSenderId:  "280384188382",
        projectId: "water-atm-d9acd")
    );
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TagReadModel()),
    ChangeNotifierProvider(create: (_) => NdefWriteModel()),
    ChangeNotifierProvider(create: (_) => TagInitiateModel()),
    ChangeNotifierProvider(create: (_) => TagInvalidateModel()),
    ChangeNotifierProvider(create: (_) => NdefBulkRechargeModel()),

  ],
  child: MyApp()));
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
      onGenerateTitle: (context) => 'PureDrop'.hardcoded,
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
