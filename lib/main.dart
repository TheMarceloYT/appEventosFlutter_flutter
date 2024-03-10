import 'package:appeventosflutter_flutter/theme/theme_provider.dart';
import 'package:appeventosflutter_flutter/utils/splashScreen_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    )
  );
}

//app principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //query
    final MediaQueryData query = MediaQuery.of(context);
    //app
    return MediaQuery(
      //valores personalizados
      data: query.copyWith(
        textScaleFactor: query.textScaleFactor.clamp(0.8, 1.2),
      ),
      //cuerpo de la app
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [const Locale('es')],
        title: 'Eventos Flutter',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        darkTheme: Provider.of<ThemeProvider>(context).themeData,
        //home
        home: SplashScreen(),
      ),
    );
  }
}
