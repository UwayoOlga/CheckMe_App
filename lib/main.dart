import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: CheckMeApp()));
}

class CheckMeApp extends ConsumerWidget {
  const CheckMeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'CheckMe – Todo App',
      theme: theme == AppTheme.dark
          ? ThemeData.dark().copyWith(
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.dark(
          primary: Colors.pink[700]!,
          secondary: Colors.pink[400]!,
        ),
      )
          : ThemeData.light().copyWith(
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.light(
          primary: Colors.pink,
          secondary: Colors.pink[200]!,
        ),
      ),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
