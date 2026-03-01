import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:leaguestats_mobile/features/home/widget/match_card_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/news_card_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/profile_icon_widget.dart';
import 'package:leaguestats_mobile/features/home/widget/team_card_widget.dart';
import 'package:leaguestats_mobile/features/profile/profile.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final Future<List<TeamListResponseDto>> _teamsFuture;
  late final Future<List<LeagueListResponseDto>> _leaguesFuture;
  late final Future<UserResponseDto> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _teamsFuture = TeamService().getAll();
    _leaguesFuture = LeagueService().getAll();
    _userProfileFuture = UserService().getCurrentUserProfile();
  }

  String _flagUrlFromCode(String? code) {
    final normalized = (code ?? '').trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg';
    }

    return 'https://flagcdn.com/w40/$normalized.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            children: [
              FutureBuilder<UserResponseDto>(
                future: _userProfileFuture,
                builder: (context, snapshot) {
                  final profile = snapshot.data;
                  final displayName =
                      profile?.username ?? profile?.user?.name ?? 'Usuario';
                  final countryName = profile?.country?.name ?? 'País';
                  final countryFlagUrl = _flagUrlFromCode(profile?.country?.flag);

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePageView(),
                            ),
                          );
                        },
                        child: const ProfileIconWidget(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    countryName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Image.network(
                                  countryFlagUrl,
                                  width: 25,
                                  height: 18,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.flag_outlined,
                                      color: Colors.white54,
                                      size: 20,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Noticias destacas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 500,
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(5),
                  children: [
                    NewsCardWidget(
                      url:
                          'https://i.ytimg.com/vi/INJIThRXsFc/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLACIdaULzS9vslgyuXE3t3L0wPHlw',
                      titulo: 'Koi gana',
                      descripcion: 'Increible victoria del conjunto español',
                    ),
                    NewsCardWidget(
                      url:
                          'https://i.ytimg.com/vi/BdlL0jr4cvY/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLAD5iscoPKbGDL4TVp79_JfYGsR6g',
                      titulo: 'G2 pierde',
                      descripcion: 'Dominio Coreano',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Ligas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 160,
                child: FutureBuilder<List<LeagueListResponseDto>>(
                  future: _leaguesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error cargando ligas',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final leagues = snapshot.data ?? [];
                    if (leagues.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay ligas disponibles',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: leagues.length,
                      itemBuilder: (context, index) {
                        final league = leagues[index];
                        final logo =
                            (league.logo != null && league.logo!.isNotEmpty)
                            ? league.logo!
                            : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg';

                        return TeamCardWidget(
                          url: logo,
                          teamName: league.name ?? 'Sin nombre',
                        );
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  Text(
                    'Equipos',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 160,
                child: FutureBuilder<List<TeamListResponseDto>>(
                  future: _teamsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Error cargando equipos',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    final teams = snapshot.data ?? [];
                    if (teams.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay equipos disponibles',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        final team = teams[index];
                        final logo = (team.logo != null && team.logo!.isNotEmpty)
                            ? team.logo!
                            : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg';

                        return TeamCardWidget(
                          url: logo,
                          teamName: team.name ?? 'Sin nombre',
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Text(
                    'Partidas destacadas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 10),
                  children: [
                    MatchCardWidget(
                      iconoLiga:
                          'https://liquipedia.net/commons/images/8/8f/LCK_2021_full_lightmode.png',
                      nombreEquipo1: 'T1',
                      nombreEquipo2: 'Gen.G',
                      paisLiga: 'Corea',
                      urlBandera:
                          'https://sipalkido.com.ar/wp-content/uploads/2025/08/depositphotos_1919144-stock-photo-flag-of-south-korea.jpg',
                    ),
                    MatchCardWidget(
                      iconoLiga:
                          'https://liquipedia.net/commons/images/8/8f/LCK_2021_full_lightmode.png',
                      nombreEquipo1: 'T1',
                      nombreEquipo2: 'Gen.G',
                      paisLiga: 'Corea',
                      urlBandera:
                          'https://sipalkido.com.ar/wp-content/uploads/2025/08/depositphotos_1919144-stock-photo-flag-of-south-korea.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        onTap: (index) {},
        items: [
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
            icon: Icon(Icons.data_usage),
            label: 'Estadisticas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }
}
