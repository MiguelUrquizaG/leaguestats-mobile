import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/games/game_response_dto.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/games_service.dart';
import 'package:leaguestats_mobile/core/services/player_service.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/features/games/bloc/games_page_bloc.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';
import 'package:leaguestats_mobile/features/players/bloc/player_page_bloc.dart'
  as player_bloc;

class GameDetailPageView extends StatefulWidget {
  final int gameId;

  const GameDetailPageView({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailPageView> createState() => _GameDetailPageViewState();
}

class _GameDetailPageViewState extends State<GameDetailPageView> {
  late final GamesPageBloc _gamesBloc;
  final TeamService _teamService = TeamService();
  final Map<int, Future<TeamListResponseDto?>> _winnerTeamFutures = {};

  @override
  void initState() {
    super.initState();
    _gamesBloc = GamesPageBloc(GamesService())
      ..add(GetByIdEvent(id: widget.gameId));
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
          'Detalle de partida',
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
                    'Error cargando partida\n${state.message}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: const Color(0xFFD1D5DB)),
                  ),
                ),
              );
            }

            if (state is GameSinglePageSuccess) {
              return _buildBody(state.dto);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(GameResponseDto game) {
    final matchUps = game.matchUps ?? [];
    final homeName = game.homeTeam?.name ?? 'T1';
    final awayName = game.awayTeam?.name ?? 'GEN';
    final homeLogo = game.homeTeam?.logo ?? '';
    final awayLogo = game.awayTeam?.logo ?? '';
    final homeTeamId = game.homeTeamId ?? game.homeTeam?.id;
    final awayTeamId = game.awayTeamId ?? game.awayTeam?.id;
    final statusLabel = game.isActive == 1 ? 'LIVE' : 'FINAL';
    final statusColor =
        game.isActive == 1 ? const Color(0xFF22D3EE) : const Color(0xFF10B981);

    final matchupCards = <Widget>[];
    var runningHomeScore = 0;
    var runningAwayScore = 0;

    for (var index = 0; index < matchUps.length; index++) {
      final matchUp = matchUps[index];
      final winnerTeamId = matchUp.winnerTeamId;

      if (winnerTeamId != null) {
        if (homeTeamId != null && winnerTeamId == homeTeamId) {
          runningHomeScore++;
        } else if (awayTeamId != null && winnerTeamId == awayTeamId) {
          runningAwayScore++;
        }
      }

      matchupCards.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _buildMatchupCard(
            matchupNumber: index + 1,
            matchUp: matchUp,
            homeName: homeName,
            awayName: awayName,
            homeLogo: homeLogo,
            awayLogo: awayLogo,
            seriesHomeScore: runningHomeScore,
            seriesAwayScore: runningAwayScore,
            statusLabel: statusLabel,
            statusColor: statusColor,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      children: [
        _buildMvpSection(game.mvpId),
        const SizedBox(height: 12),
        if (matchUps.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F23),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Text(
              'No hay matchups disponibles.',
              style: GoogleFonts.inter(color: const Color(0xFF9CA3AF)),
            ),
          )
        else
          ...matchupCards,
      ],
    );
  }

  Widget _buildMvpSection(int? mvpId) {
    if (mvpId == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF121722),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Text(
          'MVP: -',
          style: GoogleFonts.inter(
            color: const Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => player_bloc.PlayerPageBloc(PlayerService())
        ..add(player_bloc.GetByIdEvent(id: mvpId)),
      child: BlocBuilder<player_bloc.PlayerPageBloc, player_bloc.PlayerPageState>(
        builder: (context, state) {
          if (state is player_bloc.PlayerPageSuccess) {
            final player = state.dto;
            final playerName = (player.name ?? '').trim().isEmpty
                ? 'Jugador #$mvpId'
                : player.name!;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF121722),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEAB308).withOpacity(0.6),
                      ),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: ClipOval(
                      child: DynamicNetworkImage(
                        url: player.photo ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'MVP: $playerName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFEAB308),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is player_bloc.PlayerPageError) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF121722),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Text(
                'MVP: Jugador #$mvpId',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF121722),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFEAB308),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Cargando MVP...',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMatchupCard({
    required int matchupNumber,
    required MatchUps matchUp,
    required String homeName,
    required String awayName,
    required String homeLogo,
    required String awayLogo,
    required int seriesHomeScore,
    required int seriesAwayScore,
    required String statusLabel,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF121722),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'MATCHUP $matchupNumber',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTeamCompact(
                  name: homeName,
                  logoUrl: homeLogo,
                  accent: const Color(0xFF22D3EE),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B111C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Text(
                  '$seriesHomeScore:$seriesAwayScore',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
              Expanded(
                child: _buildTeamCompact(
                  name: awayName,
                  logoUrl: awayLogo,
                  accent: const Color(0xFFFF7B39),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'ASESINATOS',
                  value: '${matchUp.homeTeamKills ?? 0} - ${matchUp.awayTeamKills ?? 0}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatTile(
                  title: 'ORO TOTAL',
                  value:
                      '${_formatGold(matchUp.homeTeamGold)} - ${_formatGold(matchUp.awayTeamGold)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: 'TORRES',
                  value: '${matchUp.homeTeamTowers ?? 0} - ${matchUp.awayTeamTowers ?? 0}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatTile(
                  title: 'SIDE',
                  value:
                      '${matchUp.homeTeamSide ?? '-'} / ${matchUp.awayTeamSide ?? '-'}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: FutureBuilder<TeamListResponseDto?>(
              future: _getWinnerTeamFuture(matchUp.winnerTeamId),
              builder: (context, snapshot) {
                final winnerTeam = snapshot.data;
                final winnerName = winnerTeam?.name?.trim();
                final hasWinnerName = winnerName != null && winnerName.isNotEmpty;

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B111C),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((winnerTeam?.logo ?? '').isNotEmpty)
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: DynamicNetworkImage(
                            url: winnerTeam!.logo ?? '',
                            fit: BoxFit.contain,
                          ),
                        ),
                      if ((winnerTeam?.logo ?? '').isNotEmpty)
                        const SizedBox(width: 8),
                      Text(
                        hasWinnerName
                            ? 'Ganador: $winnerName'
                            : 'Ganador ID: ${matchUp.winnerTeamId ?? '-'}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFE5E7EB),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<TeamListResponseDto?> _getWinnerTeamFuture(int? teamId) {
    if (teamId == null) {
      return Future.value(null);
    }

    return _winnerTeamFutures.putIfAbsent(
      teamId,
      () async {
        try {
          return await _teamService.getById(teamId);
        } catch (_) {
          return null;
        }
      },
    );
  }

  Widget _buildTeamCompact({
    required String name,
    required String logoUrl,
    required Color accent,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(7),
          child: DynamicNetworkImage(url: logoUrl, fit: BoxFit.contain),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: accent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF0B111C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF6B7280),
              fontSize: 10,
              letterSpacing: .6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: const Color(0xFFE5E7EB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatGold(double? value) {
    final number = value ?? 0;
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toStringAsFixed(1);
  }
}
