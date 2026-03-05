import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:leaguestats_mobile/core/models/players/player_response_dto.dart';
import 'package:leaguestats_mobile/core/services/player_service.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/core/services/country_service.dart';

class PlayerDetailPageView extends StatefulWidget {
  final PlayerResponseDto player;

  const PlayerDetailPageView({super.key, required this.player});

  @override
  State<PlayerDetailPageView> createState() => _PlayerDetailPageViewState();
}

class _PlayerDetailPageViewState extends State<PlayerDetailPageView>
    with SingleTickerProviderStateMixin {
  late final Future<PlayerResponseDto?> _playerFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _teamName;
  String? _countryName;
  String? _countryFlag;

  @override
  void initState() {
    super.initState();
    _playerFuture = _loadPlayerDetails();
    _loadAdditionalData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<PlayerResponseDto?> _loadPlayerDetails() async {
    final playerId = widget.player.id;
    if (playerId == null) return null;

    try {
      return await PlayerService().getById(playerId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadAdditionalData() async {
    final player = widget.player;
    
    
    if (player.teamId != null) {
      try {
        final team = await TeamService().getById(player.teamId!);
        if (mounted) {
          setState(() {
            _teamName = team.name ?? 'Equipo #${player.teamId}';
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _teamName = 'Equipo #${player.teamId}';
          });
        }
      }
    }

    
    if (player.countryId != null) {
      try {
        final countries = await CountryService().getAll();
        final country = countries.firstWhere(
          (c) => c.id == player.countryId,
          orElse: () => throw Exception('País no encontrado'),
        );
        if (mounted) {
          setState(() {
            _countryName = country.name ?? 'País #${player.countryId}';
            _countryFlag = _convertToFlagEmoji(country.flag ?? '');
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _countryName = 'País #${player.countryId}';
          });
        }
      }
    }
  }

  String? _convertToFlagEmoji(String countryCode) {
    if (countryCode.isEmpty || countryCode.length != 2) return null;
    
    final code = countryCode.toUpperCase();
    final firstLetter = code.codeUnitAt(0);
    final secondLetter = code.codeUnitAt(1);
    
    
    
    final flagFirst = String.fromCharCode(0x1F1E6 + (firstLetter - 0x41));
    final flagSecond = String.fromCharCode(0x1F1E6 + (secondLetter - 0x41));
    
    return flagFirst + flagSecond;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayerResponseDto?>(
      future: _playerFuture,
      builder: (context, snapshot) {
        final resolvedPlayer = snapshot.data ?? widget.player;
        final playerName = resolvedPlayer.name ?? 'Jugador Desconocido';
        final playerPhoto = resolvedPlayer.photo ?? '';
        final position = resolvedPlayer.position ?? 'N/A';
        final kda = resolvedPlayer.kda ?? 'N/A';
        final birthDate = resolvedPlayer.birthDate ?? 'N/A';

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

              
              FadeTransition(
                opacity: _fadeAnimation,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(context, playerName),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildHeroSection(
                              playerName,
                              playerPhoto,
                              position,
                              kda,
                            ),
                            const SizedBox(height: 30),
                            _buildStatsSection(kda, position),
                            const SizedBox(height: 30),
                            _buildInfoSection(birthDate, resolvedPlayer),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String playerName) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      title: Text(
        playerName.toUpperCase(),
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 16),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border,
                  color: Colors.white, size: 20),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(
    String name,
    String photo,
    String position,
    String kda,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF9333EA).withOpacity(0.2),
                const Color(0xFF2DD4BF).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9333EA),
                      const Color(0xFF2DD4BF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9333EA).withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0F0F14),
                    image: photo.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photo),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photo.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: Color(0xFF6B7280),
                          size: 70,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              
              Text(
                name,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9333EA).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.gamepad,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      position.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
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

  Widget _buildStatsSection(String kda, String position) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1F).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: Color(0xFF9333EA),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'ESTADÍSTICAS',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.military_tech,
                  label: 'KDA',
                  value: kda,
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.emoji_events,
                  label: 'Posición',
                  value: position,
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String birthDate, PlayerResponseDto player) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1F).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF2DD4BF),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'INFORMACIÓN',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.cake_outlined,
            label: 'Fecha de Nacimiento',
            value: birthDate,
          ),
          const Divider(
            color: Color(0xFF2A2A2F),
            height: 24,
          ),
          _buildInfoRow(
            icon: Icons.public,
            label: 'País',
            value: _countryFlag != null && _countryName != null
                ? '$_countryFlag $_countryName'
                : _countryName ?? 'Cargando...',
          ),
          const Divider(
            color: Color(0xFF2A2A2F),
            height: 24,
          ),
          _buildInfoRow(
            icon: Icons.groups,
            label: 'Equipo',
            value: _teamName ?? 'Cargando...',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2DD4BF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2DD4BF),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
