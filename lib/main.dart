import 'package:flutter/material.dart';
import 'package:to_do_list/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData _theme;

  @override
  void initState() {
    _theme = darkTheme();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateTheme(context);
  }

  void updateTheme(BuildContext context) {
    final Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    if (platformBrightness == Brightness.dark) {
      setState(() {
        _theme = darkTheme();
      });
    } else {
      setState(() {
        _theme = lightTheme();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

ThemeData darkTheme(){
  return ThemeData.dark(
    useMaterial3: true,)
      .copyWith(
      colorScheme: ColorScheme.fromSeed(
          primary: Colors.deepOrange.shade800, 
          seedColor: Colors.deepOrange.shade800,
          primaryContainer: Colors.grey.shade200,
        ),
      
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 6,
        centerTitle: true,
        color: Colors.blue,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 30,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3
        )
      ),
      textTheme:  const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
          fontSize: 20
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.3,
          fontSize: 20,
          color: Colors.white
        ),
        labelMedium: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600
        ),
        labelSmall: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400
        ),
        displayLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.grey
        )
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.grey,
        contentTextStyle: TextStyle(
          color: Colors.black
        )
      )
    );
  }
ThemeData lightTheme(){
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        primary: Colors.deepOrange.shade800, 
        seedColor: Colors.deepOrange.shade800,
        primaryContainer: Colors.grey.shade200,
      ),
    
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 6,
      centerTitle: true,
      color: Colors.blue,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.3
      )
    ),
    textTheme:  const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.3,
        fontSize: 20
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.3,
        fontSize: 20,
        color: Colors.white
      ),
      labelMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w600
      ),
      labelSmall: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400
      ),
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black38
      )
    ),
    
  );
}