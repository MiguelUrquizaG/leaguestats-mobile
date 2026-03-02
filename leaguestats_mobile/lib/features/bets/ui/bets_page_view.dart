import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/services/bet_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/features/bets/bloc/bets_page_bloc.dart';
import 'package:leaguestats_mobile/features/bets/ui/add_balance_page_view.dart';
import 'package:leaguestats_mobile/features/bets/ui/betting_bottom_sheet_widget.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart';
import 'package:leaguestats_mobile/features/register/bloc/league_bloc.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';

class BetsPageView extends StatefulWidget {
  const BetsPageView({super.key});

  @override
  State<BetsPageView> createState() => _BetsPageViewState();
}

class _BetsPageViewState extends State<BetsPageView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLeague = "Todos";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE NAVEGACIÓN CORREGIDA ---
  void _showBettingModal(
    BuildContext context,
    BetResponseDto bet,
    String teamSelected,
    double odd,
    int teamId, // Añadido: ID del equipo para la API
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        // FUNDAMENTAL: Pasar los Blocs activos al modal
        providers: [
          BlocProvider.value(value: context.read<BetsPageBloc>()),
          BlocProvider.value(value: context.read<UserPageBloc>()),
        ],
        child: BettingBottomSheetWidget(
          bet: bet,
          teamSelected: teamSelected, // Corregido el nombre del parámetro
          odd: odd, // Corregido el nombre del parámetro
          teamId: teamId, // Pasamos el ID del equipo
        ),
      ),
    );
  }

  List<BetResponseDto> _applyFilters(List<BetResponseDto> allBets) {
    final query = _searchController.text.toLowerCase();
    return allBets.where((bet) {
      final matchesLeague =
          _selectedLeague == "Todos" || (bet.league?.name == _selectedLeague);
      final matchesSearch =
          query.isEmpty ||
          (bet.team1?.name?.toLowerCase().contains(query) ?? false) ||
          (bet.team2?.name?.toLowerCase().contains(query) ?? false) ||
          (bet.league?.name?.toLowerCase().contains(query) ?? false);
      return matchesLeague && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              BetsPageBloc(BetService())..add(BetsGetActiveEvent()),
        ),
        BlocProvider(
          create: (context) =>
              UserPageBloc(UserService())..add(UserProfileByEmailEvent()),
        ),
        BlocProvider(
          create: (context) =>
              LeagueBloc(LeagueService())..add(LoadLeaguesEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0C10),
        body: SafeArea(
          child: Builder(
            builder: (context) {
              return RefreshIndicator(
                color: const Color(0xFF8B5CF6),
                onRefresh: () async {
                  context.read<BetsPageBloc>().add(BetsGetActiveEvent());
                  context.read<UserPageBloc>().add(UserProfileByEmailEvent());
                  context.read<LeagueBloc>().add(LoadLeaguesEvent());
                },
                child: Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        children: [
                          _buildLiveHeader(),
                          const SizedBox(height: 16),
                          BlocBuilder<UserPageBloc, UserPageState>(
                            builder: (context, state) {
                              String balance = (state is UserPageSuccess)
                                  ? state.dto.balance?.toStringAsFixed(2) ??
                                        "0.00"
                                  : "0.00";
                              return _buildBalanceCard(
                                balance,
                                isLoading: state is UserPageLoading,
                                context:
                                    context, // Pasamos context para navegación
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildSearchBar(),
                          const SizedBox(height: 16),
                          _buildDynamicLeagueFilters(),
                          const SizedBox(height: 24),
                          BlocBuilder<BetsPageBloc, BetsPageState>(
                            builder: (context, state) {
                              if (state is BetsPageLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF8B5CF6),
                                    ),
                                  ),
                                );
                              } else if (state is BetsPageActiveSuccess) {
                                final filteredBets = _applyFilters(state.dto);
                                if (filteredBets.isEmpty)
                                  return _buildEmptyState();
                                return Column(
                                  children: filteredBets
                                      .map(
                                        (bet) =>
                                            _buildBetMatchCard(context, bet),
                                      )
                                      .toList(),
                                );
                              } else if (state is BetsPageError) {
                                return _buildErrorState(state.message);
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicLeagueFilters() {
    return BlocBuilder<LeagueBloc, LeagueState>(
      builder: (context, state) {
        List<String> names = ["Todos"];
        if (state is LeagueLoaded) {
          names.addAll(
            state.leagues.map((l) => l.name ?? "").where((n) => n.isNotEmpty),
          );
        }
        return SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: names.length,
            itemBuilder: (context, index) {
              final name = names[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedLeague = name),
                child: _buildChip(name, isSelected: _selectedLeague == name),
              );
            },
          ),
        );
      },
    );
  }

  // --- BOTONES DE CUOTAS ACTUALIZADOS ---
  Widget _buildBetMatchCard(BuildContext context, BetResponseDto bet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF161821), Color(0xFF121319)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2C35)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bet.league?.name ?? "Torneo",
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2C35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bet.instance ?? "BO3",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                '${bet.date ?? '--/--/----'} • ${bet.time ?? '--:--'}',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamRow(bet.team1?.name ?? "T1", bet.team1?.logo ?? "", "0"),
          const SizedBox(height: 12),
          _buildTeamRow(
            bet.team2?.name ?? "T2",
            bet.team2?.logo ?? "",
            "0",
            isBold: true,
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFF2A2C35), height: 1),
          const SizedBox(height: 18),
          Row(
            children: [
              // EQUIPO 1
              _buildOddButton(
                bet.team1Value?.toString() ?? "1.0",
                onTap: () => _showBettingModal(
                  context,
                  bet,
                  bet.team1?.name ?? "",
                  bet.team1Value ?? 1.0,
                  bet.team1?.id ?? 0, // Pasamos el ID del equipo 1
                ),
              ),
              const SizedBox(width: 10),
              _buildOddButton("VS", isCenter: true),
              const SizedBox(width: 10),
              // EQUIPO 2
              _buildOddButton(
                bet.team2Value?.toString() ?? "1.0",
                onTap: () => _showBettingModal(
                  context,
                  bet,
                  bet.team2?.name ?? "",
                  bet.team2Value ?? 1.0,
                  bet.team2?.id ?? 0, // Pasamos el ID del equipo 2
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES RESTANTES ---

  Widget _buildOddButton(
    String text, {
    bool isCenter = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isCenter ? Colors.transparent : const Color(0xFF1F2129),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCenter ? Colors.white10 : const Color(0xFF2A2C35),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isCenter ? Colors.white38 : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.white, size: 14),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x99EF4444),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Apuestas activas',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildSquareIcon(Icons.tune),
      ],
    );
  }

  Widget _buildBalanceCard(
    String amount, {
    bool isLoading = false,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171923), Color(0xFF13141A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2C35)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TU SALDO',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '\$$amount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddBalancePageView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2129),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 15, color: Color(0xFFC4B5FD)),
                SizedBox(width: 8),
                Text(
                  'AÑADIR SALDO',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2129),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2C35)),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Buscar eventos o equipos...',
          hintStyle: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF1F2129),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF2A2C35),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTeamRow(
    String name,
    String logo,
    String score, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2129),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2C35)),
              ),
              child: DynamicNetworkImage(url: logo, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 180,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Text(
          score,
          style: TextStyle(
            color: isBold ? Colors.white : Colors.white38,
            fontSize: 22,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSquareIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2129),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2C35)),
      ),
      child: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No hay apuestas que coincidan",
          style: TextStyle(color: Color(0xFF9CA3AF)),
        ),
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    return Center(
      child: Text(
        "Error: $msg",
        style: const TextStyle(color: Color(0xFFFCA5A5)),
      ),
    );
  }
}
