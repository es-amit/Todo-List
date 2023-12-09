import 'package:flutter/material.dart';
import 'package:to_do_list/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}


var darktheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
  colorScheme: ColorScheme.fromSeed(
      primary: Colors.deepOrange.shade800, 
      seedColor: Colors.deepOrange.shade800,
      primaryContainer: Colors.grey.shade200,
    ),
  
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    elevation: 6,
    centerTitle: true,
    color: Colors.black,
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
  iconTheme: const IconThemeData(
    color: Colors.grey,
    size: 80
  )
);
var theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      primary: Colors.deepOrange.shade800, 
      seedColor: Colors.deepOrange.shade800,
      primaryContainer: Colors.grey.shade200,
    ),
  
  brightness: Brightness.light,
  
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
  iconTheme: const IconThemeData(
    color: Colors.black38,
    size: 80
  )
  
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: darktheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}