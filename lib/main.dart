import 'package:flutter/material.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/screens/main_screen.dart';
import 'package:investment_app/services/hive_service.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: '理财App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
