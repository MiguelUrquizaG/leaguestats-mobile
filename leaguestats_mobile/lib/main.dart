import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/login/ui/login_page_view.dart';
import 'package:leaguestats_mobile/features/news/ui/news_search_page_view.dart';
import 'package:leaguestats_mobile/features/premiun/ui/premium_page.dart';
import 'package:leaguestats_mobile/features/premiun/ui/premium_success_page.dart';
import 'package:leaguestats_mobile/features/register/ui/register_real_page_view.dart';
import 'package:leaguestats_mobile/features/register/ui/register_page_view.dart';
import 'features/home/ui/home_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeagueStats',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => const RegisterPageView(),
        '/login': (context) => const LoginPageView(),
        '/home': (context) => const HomePageView(),
        '/premium': (context) => const PremiumPage(),
        '/premium_success': (context) => const PremiumSuccessPage(),
        '/register_real': (context) => const RegisterRealPageView(),
        '/news': (context) => const NewsSearchPageView(),
      },
    );
  }
}
