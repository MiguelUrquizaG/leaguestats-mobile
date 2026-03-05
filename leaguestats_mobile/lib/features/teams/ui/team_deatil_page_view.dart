import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';

class TeamDetailPageView extends StatefulWidget {
  final TeamListResponseDto team;

  const TeamDetailPageView({super.key, required this.team});

  @override
  State<TeamDetailPageView> createState() => _TeamDetailPageViewState();
}

class _TeamDetailPageViewState extends State<TeamDetailPageView> {
  late final Future<TeamListResponseDto?> _teamFuture;

  @override
  void initState() {
    super.initState();
    _teamFuture = _loadTeamDetails();
  }

  Future<TeamListResponseDto?> _loadTeamDetails() async {
    final teamId = widget.team.id;
    if (teamId == null) return null;

    try {
      return await TeamService().getById(teamId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeamListResponseDto?>(
      future: _teamFuture,
      builder: (context, snapshot) {
        final resolvedTeam = snapshot.data ?? widget.team;
        final teamName = resolvedTeam.name ?? 'Sin nombre';
        final leagueName = resolvedTeam.league?.name ?? 'Sin Liga';
        final countryName = resolvedTeam.country?.name ?? 'Internacional';
        final teamLogo = resolvedTeam.logo ?? '';
        final teamWallpaper = resolvedTeam.teamWallpaper ?? '';
        final players = resolvedTeam.players ?? [];
        final wonMatches = (resolvedTeam.wonMatches ?? 0).toString();
        final lostMatches = (resolvedTeam.lostMatches ?? 0).toString();

        return Scaffold(
          backgroundColor: const Color(0xFF09090B),
          body: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0F0F14), Color(0xFF070709)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -120,
                left: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF9333EA).withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2DD4BF).withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                top: -20,
                right: -60,
                child: Opacity(
                  opacity: 0.25,
                  child: DynamicNetworkImage(
                    url: teamLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildMainTeamCard(
                            teamName,
                            leagueName,
                            countryName,
                            players.length,
                            teamLogo,
                            teamWallpaper,
                            wonMatches,
                            lostMatches,
                          ),
                          const SizedBox(height: 40),
                          _buildSectionHeader('PLANTILLA', '${players.length} JUGADORES'),
                          const SizedBox(height: 20),
                          if (snapshot.connectionState == ConnectionState.waiting &&
                              players.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: Color(0xFF9333EA),
                              ),
                            )
                          else if (players.isEmpty)
                            _buildEmptyState()
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: players.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) =>
                                  _buildEnhancedPlayerCard(players[index]),
                            ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      title: const Text(
        'Detalle del Equipo',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainTeamCard(
    String name,
    String league,
    String country,
    int count,
    String logo,
    String wallpaper,
    String wins,
    String losses,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03), 
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              if (wallpaper.isNotEmpty)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.12,
                    child: DynamicNetworkImage(url: wallpaper, fit: BoxFit.cover),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    _buildLogoGlow(logo),
                    const SizedBox(height: 25),
                    Text(
                      name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildLeagueBadge(league),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(Icons.public, country, "REGIÓN"),
                        Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
                        _buildStatItem(Icons.person_outline, count.toString(), "JUGADORES"),
                        Container(width: 1, height: 30, color: Colors.white.withOpacity(0.1)),
                        _buildStatItem(Icons.emoji_events_outlined, '$wins-$losses', "W/L"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoGlow(String url) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF9333EA).withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9333EA).withOpacity(0.15),
            blurRadius: 50,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: DynamicNetworkImage(url: url, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildEnhancedPlayerCard(Players player) {
    final kda = (player.kda ?? '').trim().isNotEmpty ? player.kda! : 'N/A';
    final position = (player.position ?? '').trim().isNotEmpty
        ? player.position!.toUpperCase()
        : 'PRO PLAYER';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color(0xFF18181B),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: DynamicNetworkImage(url: player.photo ?? ''),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name ?? 'Jugador',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMetaChip(position, const Color(0xFFA855F7)),
                    const SizedBox(width: 8),
                    _buildMetaChip('KDA $kda', const Color(0xFF2DD4BF)),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.2), size: 14),
        ],
      ),
    );
  }

  Widget _buildMetaChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF9333EA), size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF9333EA).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(subtitle, style: const TextStyle(color: Color(0xFFA855F7), fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildLeagueBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.group_off_outlined, color: Colors.white.withOpacity(0.1), size: 60),
          const SizedBox(height: 10),
          const Text("SIN JUGADORES REGISTRADOS", style: TextStyle(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}