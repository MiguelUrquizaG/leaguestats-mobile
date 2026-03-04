import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';
import 'package:leaguestats_mobile/core/services/player_service.dart';
import 'package:leaguestats_mobile/features/players/bloc/player_page_bloc.dart';
import 'package:leaguestats_mobile/features/players/ui/player_detail_page_view.dart';

class PlayersPageView extends StatefulWidget {
  const PlayersPageView({super.key});

  @override
  State<PlayersPageView> createState() => _PlayersPageViewState();
}

class _PlayersPageViewState extends State<PlayersPageView> {
  final TextEditingController _searchController = TextEditingController();
  late final PlayerPageBloc _playerBloc;

  String _selectedPosition = 'Todos';
  final List<String> _positions = [
    'Todos',
    'Top',
    'Jungle',
    'Mid',
    'ADC',
    'Support',
  ];

  @override
  void initState() {
    super.initState();
    _playerBloc = PlayerPageBloc(PlayerService())..add(GetAllEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _playerBloc.close();
    super.dispose();
  }

  List<PlayerResponseDto> _filterPlayers(List<PlayerResponseDto> players) {
    final query = _searchController.text.trim().toLowerCase();

    return players.where((player) {
      bool matchesPosition = true;
      if (_selectedPosition != 'Todos') {
        matchesPosition =
            player.position?.toLowerCase() == _selectedPosition.toLowerCase();
      }

      bool matchesQuery = true;
      if (query.isNotEmpty) {
        matchesQuery = (player.name?.toLowerCase().contains(query) ?? false) ||
            (player.position?.toLowerCase().contains(query) ?? false);
      }

      return matchesPosition && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: BlocProvider.value(
          value: _playerBloc,
          child: Column(
            children: [
              _buildTopBar(),
              _buildPositionFilter(),
              Expanded(
                child: BlocBuilder<PlayerPageBloc, PlayerPageState>(
                  builder: (context, state) {
                    if (state is PlayerPageInitial || state is PlayerPageLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9333EA),
                        ),
                      );
                    }

                    if (state is PlayerPageError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF4444),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error al cargar jugadores',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFD1D5DB),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is AllPlayersPageSuccess) {
                      final filteredPlayers = _filterPlayers(state.dto);

                      if (filteredPlayers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                color: Color(0xFF6B7280),
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron jugadores',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF9CA3AF),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: filteredPlayers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _buildPlayerCard(filteredPlayers[index]);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF1F1F23),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Jugadores',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F23),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
              cursorColor: const Color(0xFF9333EA),
              decoration: InputDecoration(
                hintText: 'Buscar jugador...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF6B7280),
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF6B7280),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Color(0xFF6B7280),
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _positions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final position = _positions[index];
          final isSelected = _selectedPosition == position;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPosition = position;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF9333EA)
                    : const Color(0xFF1F1F23),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF9333EA)
                      : Colors.white.withOpacity(0.05),
                ),
              ),
              child: Center(
                child: Text(
                  position,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF9CA3AF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerCard(PlayerResponseDto player) {
    final String photoUrl = player.photo ?? '';
    final String playerName = player.name ?? 'Jugador desconocido';
    final String position = player.position ?? 'N/A';
    final String kda = player.kda ?? 'N/A';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1F1F23),
            const Color(0xFF1F1F23).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlayerDetailPageView(player: player),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar del jugador
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9333EA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0F0F11),
                      image: photoUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: Color(0xFF6B7280),
                            size: 36,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Info del jugador
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playerName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildStatChip(
                            icon: Icons.gamepad,
                            text: position,
                            color: const Color(0xFF9333EA),
                          ),
                          const SizedBox(width: 8),
                          _buildStatChip(
                            icon: Icons.military_tech,
                            text: 'KDA: $kda',
                            color: const Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Flecha de navegación
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF6B7280),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
