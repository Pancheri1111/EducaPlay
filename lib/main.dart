import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EducaPlayApp(),
    ),
  );
}

class EducaPlayApp extends StatelessWidget {
  const EducaPlayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EducaPlay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const HomePage(),
    );
  }
}
