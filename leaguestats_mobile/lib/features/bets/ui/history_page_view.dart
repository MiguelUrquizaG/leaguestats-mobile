import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/user_bet_dto.dart';
import 'package:leaguestats_mobile/core/services/settings_service.dart';
import 'package:leaguestats_mobile/features/bets/bloc/bets_page_bloc.dart';
import 'package:leaguestats_mobile/features/bets/widgets/bet_history_card.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart';

class HistoryPageView extends StatefulWidget {
  const HistoryPageView({super.key});

  @override
  State<HistoryPageView> createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<HistoryPageView>
    with SingleTickerProviderStateMixin {
  static const double _fallbackPremiumMultiplier = 1.20;

  late TabController _tabController;
  final SettingsService _settingsService = SettingsService();
  double _premiumMultiplier = _fallbackPremiumMultiplier;

  bool _isOpenStatus(String? status) {
    final normalized = (status ?? '').trim().toLowerCase();
    return normalized == 'active' ||
        normalized == 'live' ||
        normalized == 'open' ||
        normalized == 'opened' ||
        normalized == 'pending';
  }

  Color _getClosedBetColor(int? awarded) {
    if (awarded == 1) {
      return const Color(0xFF10b981); 
    } else {
      return const Color(0xFFef4444); 
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<BetsPageBloc>().add(LoadUserBetsHistoryEvent());
    _loadPremiumMultiplier();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userBloc = context.read<UserPageBloc?>();
      if (userBloc != null && userBloc.state is! UserPageSuccess) {
        userBloc.add(UserProfileByEmailEvent());
      }
    });
  }

  Future<void> _loadPremiumMultiplier() async {
    try {
      final multiplier = await _settingsService.getPremiumMultiplier();
      if (!mounted) return;
      setState(() {
        _premiumMultiplier = multiplier;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserPageBloc?>()?.state;
    final isPremiumUser =
        userState is UserPageSuccess && userState.dto.isPremium == 1;

    return Scaffold(
      backgroundColor: const Color(0xFF050505), 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF050505).withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Historial',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),
                
                
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF8b5cf6),
                    indicatorWeight: 2,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    tabs: const [
                      Tab(text: 'Activas'),
                      Tab(text: 'Cerradas'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<BetsPageBloc, BetsPageState>(
            builder: (context, state) {
              if (state is BetsPageLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8b5cf6)),
                );
              }

              if (state is BetsPageError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error al cargar historial',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.read<BetsPageBloc>().add(
                          LoadUserBetsHistoryEvent(),
                        ),
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Color(0xFF8b5cf6)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is! UserBetsHistorySuccess) {
                return const SizedBox.shrink();
              }

              final activeBets = state.bets
                  .where((item) => _isOpenStatus(item.bet?.status))
                  .toList();

              return Column(
                children: [
                  if (isPremiumUser)
                    _buildPremiumNotice(
                      message:
                          'Premium activo: retornos calculados con x${_premiumMultiplier.toStringAsFixed(2)}',
                    ),
                  Expanded(
                    child: _buildBetsList(
                      activeBets,
                      emptyMessage: 'No tienes apuestas activas',
                      isPremiumUser: isPremiumUser,
                    ),
                  ),
                ],
              );
            },
          ),
          BlocBuilder<BetsPageBloc, BetsPageState>(
            builder: (context, state) {
              if (state is BetsPageLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8b5cf6)),
                );
              }

              if (state is BetsPageError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Error al cargar historial',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.read<BetsPageBloc>().add(
                          LoadUserBetsHistoryEvent(),
                        ),
                        child: const Text(
                          'Reintentar',
                          style: TextStyle(color: Color(0xFF8b5cf6)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is! UserBetsHistorySuccess) {
                return const SizedBox.shrink();
              }

              final closedBets = state.bets
                  .where((item) => !_isOpenStatus(item.bet?.status))
                  .toList();

              return Column(
                children: [
                  if (isPremiumUser)
                    _buildPremiumNotice(
                      message:
                          'Premium activo: retornos calculados con x${_premiumMultiplier.toStringAsFixed(2)}',
                    ),
                  Expanded(
                    child: _buildBetsList(
                      closedBets,
                      emptyMessage: 'No hay apuestas cerradas',
                      isPremiumUser: isPremiumUser,
                      colorizeByResult: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBetsList(
    List<UserBetDto> bets, {
    required String emptyMessage,
    required bool isPremiumUser,
    bool colorizeByResult = false,
  }) {
    if (bets.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Color(0xFF6b7280), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: bets.length,
      itemBuilder: (context, index) {
        final item = bets[index];
        final bet = item.bet;

        final amount = (item.amount ?? 0).toDouble();

        final selectedTeamId = item.winnerSelected;
        final isTeam1Selected =
            selectedTeamId != null && selectedTeamId == bet?.team1?.id;

        final selectedTeamName = isTeam1Selected
            ? (bet?.team1?.name ?? 'Team 1')
            : (bet?.team2?.name ?? 'Team 2');

        final selectedOdd = isTeam1Selected
            ? (bet?.team1Value ?? 1).toDouble()
            : (bet?.team2Value ?? 1).toDouble();

        final basePotentialReturn = amount * selectedOdd;
        final potentialReturn = isPremiumUser
          ? basePotentialReturn * _premiumMultiplier
          : basePotentialReturn;
        final cashOutValue = potentialReturn - amount;

        final cardColor = colorizeByResult
            ? _getClosedBetColor(item.awarded)
            : const Color(0xFF8b5cf6);

        return BetHistoryCard(
          gameName: bet?.league?.name ?? 'Esports',
          gameIcon: Icons.sports_esports,
          gameIconColor: cardColor,
          gameIconBgColor: cardColor.withValues(alpha: 0.2),
          isLive: (bet?.status ?? '').toLowerCase() == 'live',
          time: '${bet?.date ?? ''} ${bet?.time ?? ''}'.trim(),
          eventName: bet?.instance ?? 'Partida',
          team1: bet?.team1?.name ?? 'Team 1',
          team2: bet?.team2?.name ?? 'Team 2',
          predictionLabel: '$selectedTeamName Gana',
          predictionValue: selectedTeamName,
          odds: selectedOdd.toStringAsFixed(2),
          betAmount: '\$${amount.toStringAsFixed(2)}',
          potentialReturn: '\$${potentialReturn.toStringAsFixed(2)}',
          cashOutAvailable: _isOpenStatus(bet?.status),
          cashOutAmount: '\$${cashOutValue.toStringAsFixed(2)}',
          primaryColor: cardColor,
        );
      },
    );
  }

  Widget _buildPremiumNotice({required String message}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF8b5cf6).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF8b5cf6).withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: Color(0xFFC4B5FD),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFEDE9FE),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
