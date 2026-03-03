import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/leagues/league_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/features/leagues/bloc/league_bloc.dart';
import 'package:leaguestats_mobile/features/leagues/ui/league_detail_page_view.dart';
import 'package:leaguestats_mobile/features/login/ui/menu_component.dart';
import 'package:leaguestats_mobile/features/others/dynamic_network_image.dart';

class LeaguesSearchPageView extends StatefulWidget {
  const LeaguesSearchPageView({super.key});

  @override
  State<LeaguesSearchPageView> createState() => _LeaguesSearchPageViewState();
}

class _LeaguesSearchPageViewState extends State<LeaguesSearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  late final LeagueBloc _leagueBloc;

  String _selectedTab = 'Todos';

  @override
  void initState() {
    super.initState();
    _leagueBloc = LeagueBloc(LeagueService())..add(LoadLeaguesEvent());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _leagueBloc.close();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<LeagueListResponseDto> _filterLeagues(List<LeagueListResponseDto> leagues) {
    final query = _searchController.text.trim().toLowerCase();

    return leagues.where((league) {
      final countryName = (league.country?.name ?? '').toLowerCase();
      final leagueName = (league.name ?? '').toLowerCase();

      final matchesTab =
          _selectedTab == 'Todos' || countryName == _selectedTab.toLowerCase();

      final matchesQuery =
          query.isEmpty || leagueName.contains(query) || countryName.contains(query);

      return matchesTab && matchesQuery;
    }).toList();
  }

  List<String> _buildTabs(List<LeagueListResponseDto> leagues) {
    final countries = leagues
        .map((league) => (league.country?.name ?? '').trim())
        .where((country) => country.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return ['Todos', ...countries.take(6)];
  }

  void _onBottomNavTap(int index) {
    if (index == 4) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const FractionallySizedBox(
          heightFactor: 0.65,
          child: MenuComponent(),
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, '/home', arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF9333EA).withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              bottom: -130,
              left: -90,
              child: Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2563EB).withOpacity(0.10),
                ),
              ),
            ),
            BlocProvider.value(
              value: _leagueBloc,
              child: BlocBuilder<LeagueBloc, LeagueState>(
                builder: (context, state) {
                  if (state is LeagueInitial || state is LeagueLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF9333EA)),
                    );
                  }

                  if (state is LeagueError) {
                    return Center(
                      child: Text(
                        'Error cargando ligas',
                        style: GoogleFonts.inter(color: const Color(0xFFD1D5DB)),
                      ),
                    );
                  }

                  if (state is LeagueLoaded) {
                    final leagues = state.leagues;
                    final tabs = _buildTabs(leagues);

                    if (!tabs.contains(_selectedTab)) {
                      _selectedTab = 'Todos';
                    }

                    final filteredLeagues = _filterLeagues(leagues);

                    return Column(
                      children: [
                        _buildHeaderTitle(filteredLeagues.length),
                        _buildTopBar(),
                        _buildTabsRow(tabs),
                        Expanded(
                          child: filteredLeagues.isEmpty
                              ? _buildEmptyState()
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                                  itemCount: filteredLeagues.length,
                                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    return _buildLeagueCard(filteredLeagues[index]);
                                  },
                                ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Noticias'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Apuestas'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Equipos'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Row(
        children: [
          Text(
            'Ligas',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA).withOpacity(0.20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF9333EA).withOpacity(0.5)),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.inter(
                color: const Color(0xFFE9D5FF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F23).withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: TextField(
          controller: _searchController,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          cursorColor: const Color(0xFF9333EA),
          decoration: InputDecoration(
            hintText: 'Buscar ligas...',
            hintStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9CA3AF), size: 18),
                    onPressed: () => _searchController.clear(),
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsRow(List<String> tabs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _selectedTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9333EA).withOpacity(0.22)
                      : const Color(0xFF1F1F23),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9333EA)
                        : Colors.white.withOpacity(0.06),
                  ),
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? const Color(0xFFE9D5FF)
                        : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeagueCard(LeagueListResponseDto league) {
    return GestureDetector(
      onTap: () {
        if (league.id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LeagueDetailPageView(leagueId: league.id!, league: league),
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF23262F), Color(0xFF1B1D24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.1,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: DynamicNetworkImage(url: league.logo ?? '', fit: BoxFit.contain),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: DynamicNetworkImage(url: league.logo ?? '', fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            league.name ?? 'Sin nombre',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.public, color: Colors.blueAccent, size: 14),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  league.country?.name ?? 'Sin país',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF9CA3AF),
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F23).withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, color: Color(0xFF9CA3AF), size: 30),
            const SizedBox(height: 10),
            Text(
              'No se encontraron ligas',
              style: GoogleFonts.inter(
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
