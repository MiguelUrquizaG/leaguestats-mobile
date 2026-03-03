import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/premiun/ui/premium_page.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/features/profile/ui/profile_page_view.dart';
import 'package:leaguestats_mobile/features/news/ui/news_search_page_view.dart';
import 'package:leaguestats_mobile/features/bets/ui/bets_page_view.dart';
import 'package:leaguestats_mobile/features/teams/ui/teams_search_page_view.dart';
import 'package:leaguestats_mobile/features/leagues/ui/leagues_search_page_view.dart';

class MenuComponent extends StatefulWidget {
  const MenuComponent({super.key});

  @override
  State<MenuComponent> createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  late Future<UserResponseDto> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getCurrentUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseDto>(
      future: _userFuture,
      builder: (context, snapshot) {
        final userData = snapshot.data;
        
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00E5FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                              children: [
                                TextSpan(
                                  text: 'LEAGUE',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'STATS',
                                  style: TextStyle(color: Color(0xFF00E5FF)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Profile Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ProfileCard(userData: userData),
                ),
                const SizedBox(height: 24),
                // Menu Items
                _MenuItem(
                  icon: Icons.newspaper,
                  title: 'Noticias',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NewsSearchPageView()),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.grid_view_rounded,
                  title: 'Apuestas',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BetsPageView()),
                    );
                  },
                ),
                const _MenuItem(
                  icon: Icons.bar_chart_rounded,
                  title: 'Estadísticas',
                ),
                _MenuItem(
                  icon: Icons.groups_rounded,
                  title: 'Equipos',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TeamsSearchPageView()),
                    );
                  },
                ),
                _MenuItem(
                  icon: Icons.emoji_events_rounded,
                  title: 'Ligas',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LeaguesSearchPageView()),
                    );
                  },
                ),
                const _MenuItem(
                  icon: Icons.person_rounded,
                  title: 'Jugadores',
                ),
                const _MenuItem(
                  icon: Icons.military_tech_rounded,
                  title: 'Campeones',
                ),
                const SizedBox(height: 8),
                // Premium Item
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _PremiumMenuItem(),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserResponseDto? userData;
  
  const _ProfileCard({this.userData});

  @override
  Widget build(BuildContext context) {
    final username = userData?.username ?? userData?.user?.name ?? 'Usuario';
    final email = userData?.user?.email ?? 'email@ejemplo.com';
    final isPremium = userData?.isPremium == 1;
    final membershipLabel = isPremium ? 'PRO MEMBER' : 'FREE MEMBER';
    final avatarUrl = 'https://i.pravatar.cc/150?u=$email';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isPremium ? const Color(0xFF00E5FF) : Colors.grey,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              if (isPremium)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E5FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${email.split('@')[0]}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPremium 
                        ? const Color(0xFF00E5FF).withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isPremium 
                          ? const Color(0xFF00E5FF).withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    membershipLabel,
                    style: TextStyle(
                      color: isPremium ? const Color(0xFF00E5FF) : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePageView()),
              );
            },
            child: const Text(
              'Ver',
              style: TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: const Color(0xFF00E5FF).withValues(alpha: 0.1),
          highlightColor: const Color(0xFF00E5FF).withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF00E5FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[600],
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumMenuItem extends StatelessWidget {
  const _PremiumMenuItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00E5FF),
            Color(0xFF0099CC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PremiumPage()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hazte Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Desbloquea todas las funciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
