import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/teams/team_list_response_dto.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/features/teams/bloc/team_bloc.dart';
import 'package:leaguestats_mobile/features/teams/ui/team_deatil_page_view.dart';

class TeamsSearchPageView extends StatefulWidget {
  const TeamsSearchPageView({super.key});

  @override
  State<TeamsSearchPageView> createState() => _TeamsSearchPageView();
}

class _TeamsSearchPageView extends State<TeamsSearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  late final TeamBloc _teamBloc;

  String _selectedTab = 'Todos';

  @override
  void initState() {
    super.initState();
    
    _teamBloc = TeamBloc(TeamService())..add(LoadTeamsEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _teamBloc.close();
    super.dispose();
  }

  
  List<TeamListResponseDto> _filterTeams(List<TeamListResponseDto> teams) {
    final query = _searchController.text.trim().toLowerCase();

    return teams.where((team) {
      
      bool matchesTab = true;
      if (_selectedTab != 'Todos') {
        matchesTab = team.league?.name == _selectedTab;
      }

      
      bool matchesQuery = true;
      if (query.isNotEmpty) {
        matchesQuery =
            team.name!.toLowerCase().contains(query) ||
            (team.league?.name?.toLowerCase().contains(query) ?? false);
      }

      return matchesTab && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: BlocProvider.value(
          value: _teamBloc,
          child: Column(
            children: [
              _buildTopBar(),
              _buildTabs(),
              Expanded(
                child: BlocBuilder<TeamBloc, TeamState>(
                  builder: (context, state) {
                    if (state is TeamInitial || state is TeamLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9333EA),
                        ),
                      );
                    }

                    if (state is TeamError) {
                      return Center(
                        child: Text(
                          'Error cargando equipos',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                      );
                    }

                    if (state is TeamLoaded) {
                      final filteredTeams = _filterTeams(state.teams);

                      if (filteredTeams.isEmpty) {
                        return Center(
                          child: Text(
                            'No se encontraron equipos',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: filteredTeams.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return _buildTeamCard(filteredTeams[index]);
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F23),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                cursorColor: const Color(0xFF9333EA),
                decoration: InputDecoration(
                  hintText: 'Buscar equipos o ligas...',
                  hintStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    
    final List<String> categories = ['Todos', 'LEC', 'LCK', 'LCS', 'LVP'];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((name) {
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = name),
                child: _buildTab(name, isSelected: _selectedTab == name),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color(0xFF9333EA) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isSelected ? const Color(0xFF9333EA) : const Color(0xFF9CA3AF),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTeamCard(TeamListResponseDto team) {

    return GestureDetector(
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeamDetailPageView(team: team)),
        );
      },
    child:  Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF1F1F23),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                child: Image.network(team.logo ?? '', width: 140, height: 140),
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
                    child: Image.network(team.logo ?? '', fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          team.name ?? 'Sin nombre',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              team.league?.name ?? 'Independiente',
                              style: GoogleFonts.inter(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            _buildStatBadge(
                              "W",
                              team.wonMatches.toString(),
                              Colors.green,
                            ),
                            const SizedBox(width: 8),
                            _buildStatBadge(
                              "L",
                              team.lostMatches.toString(),
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        "$label: $value",
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
