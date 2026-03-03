import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';
import 'package:leaguestats_mobile/core/services/games_service.dart';
import 'package:leaguestats_mobile/features/games/bloc/games_page_bloc.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';

class GamesResultsPageView extends StatefulWidget {
  const GamesResultsPageView({super.key});

  @override
  State<GamesResultsPageView> createState() => _GamesResultsPageViewState();
}

class _GamesResultsPageViewState extends State<GamesResultsPageView> {
  late final GamesPageBloc _gamesBloc;

  @override
  void initState() {
    super.initState();
    _gamesBloc = GamesPageBloc(GamesService())..add(GetAllEvent());
  }

  @override
  void dispose() {
    _gamesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F11),
        elevation: 0,
        title: Text(
          'Resultados',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocProvider.value(
        value: _gamesBloc,
        child: BlocBuilder<GamesPageBloc, GamesPageState>(
          builder: (context, state) {
            if (state is GamesPageInitial || state is GamesPageLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF9333EA)),
              );
            }

            if (state is GamesPageError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Error cargando partidas\n${state.message}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: const Color(0xFFD1D5DB)),
                  ),
                ),
              );
            }

            if (state is GamesPageSuccess) {
              if (state.dto.isEmpty) {
                return Center(
                  child: Text(
                    'No hay partidas disponibles',
                    style: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                itemCount: state.dto.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) => _buildGameCard(state.dto[index]),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildGameCard(GameResponseDto game) {
    final homeName = game.homeTeam?.name ?? 'Equipo local';
    final awayName = game.awayTeam?.name ?? 'Equipo visitante';
    final homeLogo = game.homeTeam?.logo ?? '';
    final awayLogo = game.awayTeam?.logo ?? '';
    final homeScore = game.homeTeamScore ?? 0;
    final awayScore = game.awayTeamScore ?? 0;
    final playedMatches = game.matchUps?.length ?? 0;
    final boLabel = _getBoLabelFromData(
      playedMatches: playedMatches,
      maxGames: game.maxGames,
    );
    final leagueLabel = game.leagueId != null ? 'Liga #${game.leagueId}' : 'Liga';
    final statusLabel = game.isActive == 1 ? 'EN JUEGO' : 'FINALIZADO';
    final statusBaseColor =
        game.isActive == 1 ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171B24), Color(0xFF11141B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildMetaChip(leagueLabel),
              const SizedBox(width: 8),
              _buildMetaChip(boLabel),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBaseColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusBaseColor.withOpacity(0.45)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    color: statusBaseColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTeamSide(
                  name: homeName,
                  logoUrl: homeLogo,
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 96),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Text(
                  '$homeScore:$awayScore',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    letterSpacing: -1.2,
                    height: 1,
                  ),
                ),
              ),
              Expanded(
                child: _buildTeamSide(
                  name: awayName,
                  logoUrl: awayLogo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSide({
    required String name,
    required String logoUrl,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: DynamicNetworkImage(url: logoUrl, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: const Color(0xFFE5E7EB),
            fontWeight: FontWeight.w700,
            fontSize: 12,
            height: 1.15,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFF9CA3AF),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getBoLabelFromData({
    required int playedMatches,
    required int? maxGames,
  }) {
    if (playedMatches > 0) {
      if (playedMatches >= 3) return 'BO5';
      if (playedMatches >= 2) return 'BO3';
      return 'BO1';
    }

    if (maxGames != null) {
      if (maxGames >= 5) return 'BO5';
      if (maxGames >= 3) return 'BO3';
    }

    return 'BO1';
  }
}
