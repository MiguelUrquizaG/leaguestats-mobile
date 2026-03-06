import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/features/news/ui/news_detail_page.dart';

// Blocs
import 'package:leaguestats_mobile/features/leagues/bloc/league_bloc.dart';
import 'package:leaguestats_mobile/features/teams/bloc/team_bloc.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';
import 'package:leaguestats_mobile/features/teams/ui/team_deatil_page_view.dart';
import 'package:leaguestats_mobile/features/teams/ui/teams_search_page_view.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart';
import 'package:leaguestats_mobile/features/leagues/ui/leagues_search_page_view.dart';
import 'package:leaguestats_mobile/features/leagues/ui/league_detail_page_view.dart';
import 'package:leaguestats_mobile/features/login/ui/menu_component.dart';

// Servicios
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';

// UI
import 'package:leaguestats_mobile/features/home/widget/news_card_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/profile_icon_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/team_card_widget.dart';
import 'package:leaguestats_mobile/features/news/ui/news_search_page_view.dart';
import 'package:leaguestats_mobile/features/profile/profile.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final TeamBloc _teamBloc;
  late final LeagueBloc _leagueBloc;
  late final NewsPageBloc _newsBloc;
  late final UserPageBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _teamBloc = TeamBloc(TeamService())..add(LoadTeamsEvent());
    _leagueBloc = LeagueBloc(LeagueService())..add(LoadLeaguesEvent());
    _newsBloc = NewsPageBloc(NewsService())..add(NewsGetAllEvent());
    _userBloc = UserPageBloc(UserService())..add(UserProfileByEmailEvent());
  }

  @override
  void dispose() {
    _teamBloc.close();
    _leagueBloc.close();
    _newsBloc.close();
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _teamBloc),
        BlocProvider.value(value: _leagueBloc),
        BlocProvider.value(value: _newsBloc),
        BlocProvider.value(value: _userBloc),
      ],
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  String _flagUrlFromCode(String? code) {
    final normalized = (code ?? '').trim().toLowerCase();
    if (normalized.isEmpty)
      return 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg';
    return 'https://flagcdn.com/w40/$normalized.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FractionallySizedBox(
                  heightFactor: 0.65,
                  child: MenuComponent(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            BlocBuilder<UserPageBloc, UserPageState>(
              builder: (context, state) {
                if (state is UserPageSuccess) {
                  final profile = state.dto;
                  final displayName =
                      profile.username ?? profile.user?.name ?? 'Usuario';
                  return _buildHeader(context, profile, displayName);
                }

                return const SizedBox(
                  height: 80,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            _buildSectionTitle(
              context,
              'Noticias destacadas',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewsSearchPageView()),
              ),
            ),

            SizedBox(
              height: 200,
              child: BlocBuilder<NewsPageBloc, NewsPageState>(
                builder: (context, state) {
                  if (state is NewsPageSuccess) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: state.dto.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 20),
                      itemBuilder: (context, index) {
                        final item = state.dto[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailPage(newsId: item.id),
                              ),
                            );
                          },
                          child: NewsCardWidget(
                            id: item.id,
                            url: item.photo,
                            titulo: item.title,
                            descripcion: item.description,
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            const SizedBox(height: 10),
            _buildSectionTitle(
              context,
              'Ligas',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LeaguesSearchPageView(),
                ),
              ),
            ),

            SizedBox(
              height: 160,
              child: BlocBuilder<LeagueBloc, LeagueState>(
                builder: (context, state) {
                  if (state is LeagueLoaded) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.leagues.length,
                      itemBuilder: (context, index) {
                        final league = state.leagues[index];
                        return GestureDetector(
                          onTap: () {
                            if (league.id == null) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeagueDetailPageView(
                                  leagueId: league.id!,
                                  league: league,
                                ),
                              ),
                            );
                          },
                          child: TeamCardWidget(
                            url: league.logo ?? '',
                            teamName: league.name ?? 'Sin nombre',
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            _buildSectionTitle(
              context,
              'Equipos',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TeamsSearchPageView()),
              ),
            ),

            SizedBox(
              height: 160,
              child: BlocBuilder<TeamBloc, TeamState>(
                builder: (context, state) {
                  if (state is TeamLoaded) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: state.teams.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final team = state.teams[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TeamDetailPageView(team: team),
                              ),
                            );
                          },
                          child: TeamCardWidget(
                            url: team.logo ?? '',
                            teamName: team.name ?? 'Sin nombre',
                          ),
                        );
                      },
                    );
                  }

                  if (state is TeamError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Error al cargar equipos',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                context.read<TeamBloc>().add(LoadTeamsEvent()),
                            child: const Text(
                              'Reintentar',
                              style: TextStyle(color: Color(0xFF8b5cf6)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    dynamic profile,
    String displayName,
  ) {
    final isPremium = (profile?.isPremium ?? 0) == 1;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePageView()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isPremium
                ? [
                    const Color(0xFF1d72fe).withOpacity(0.15),
                    const Color(0xFF1d72fe).withOpacity(0.05),
                  ]
                : [
                    Colors.deepPurple.withOpacity(0.15),
                    Colors.deepPurple.withOpacity(0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: (isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple)
                .withOpacity(0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple)
                  .withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ProfileIconWidget(isPremium: isPremium),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: isPremium
                                ? const Color(0xFF1d72fe)
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPremium)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1d72fe).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF1d72fe).withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFF1d72fe),
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'PRO',
                                style: TextStyle(
                                  color: Color(0xFF1d72fe),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color:
                            (isPremium
                                    ? const Color(0xFF1d72fe)
                                    : Colors.deepPurple)
                                .withOpacity(0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          profile.country?.name ?? 'País desconocido',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          _flagUrlFromCode(profile.country?.flag),
                          width: 24,
                          height: 16,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.flag,
                            color:
                                (isPremium
                                        ? const Color(0xFF1d72fe)
                                        : Colors.deepPurple)
                                    .withOpacity(0.5),
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: (isPremium ? const Color(0xFF1d72fe) : Colors.deepPurple)
                    .withOpacity(0.8),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title, {
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        // TextButton(
        //   onPressed: onTap,
        //   child: const Text('Ver todo', style: TextStyle(color: Colors.grey)),
        // ),
      ],
    );
  }
}
