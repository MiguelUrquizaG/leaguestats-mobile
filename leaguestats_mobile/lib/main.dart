import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/login/ui/login_page_view.dart';
import 'package:leaguestats_mobile/features/premiun/ui/premium_page.dart';
import 'package:leaguestats_mobile/features/premiun/ui/premium_success_page.dart';
import 'package:leaguestats_mobile/features/register/ui/register_real_page_view.dart';
import 'package:leaguestats_mobile/features/register/ui/register_page_view.dart';
import 'package:leaguestats_mobile/features/news/ui/news_search_page_view.dart';
import 'package:leaguestats_mobile/features/teams/ui/teams_search_page_view.dart';
import 'package:leaguestats_mobile/features/bets/ui/bets_page_view.dart';
import 'package:leaguestats_mobile/features/login/ui/menu_component.dart';
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
        '/home': (context) => const MainNavigationPage(),
        '/premium': (context) => const PremiumPage(),
        '/premium_success': (context) => const PremiumSuccessPage(),
        '/register_real': (context) => const RegisterRealPageView(),
      },
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageView(),
    const NewsSearchPageView(),
    const BetsPageView(),
    const TeamsSearchPageView(),
    const SizedBox(), // Placeholder para el menú modal
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // Mostrar el menú modal en lugar de navegar
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const FractionallySizedBox(
          heightFactor: 0.65,
          child: MenuComponent(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Apuestas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
