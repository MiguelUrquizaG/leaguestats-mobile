import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/core/services/settings_service.dart';
import 'package:leaguestats_mobile/features/bets/bloc/bets_page_bloc.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart';

class BettingBottomSheetWidget extends StatefulWidget {
  final BetResponseDto bet;
  final String teamSelected;
  final double odd;
  final int teamId;

  const BettingBottomSheetWidget({
    super.key,
    required this.bet,
    required this.teamSelected,
    required this.odd,
    required this.teamId,
  });

  @override
  State<BettingBottomSheetWidget> createState() =>
      _BettingBottomSheetWidgetState();
}

class _BettingBottomSheetWidgetState extends State<BettingBottomSheetWidget> {
  static const double _fallbackPremiumMultiplier = 1.20;
  final SettingsService _settingsService = SettingsService();

  double _premiumMultiplier = _fallbackPremiumMultiplier;
  int selectedAmount = 200;
  final List<int> presetAmounts = [5, 20, 50, 100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();
    context.read<BetsPageBloc>().add(
      LoadPreviousBetEvent(betId: widget.bet.id!),
    );
    _loadPremiumMultiplier();
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userState = context.watch<UserPageBloc>().state;
    final isPremiumUser =
        userState is UserPageSuccess && userState.dto.isPremium == 1;

    final sheetColor = isDarkMode
        ? const Color(0xFF23252B)
        : const Color(0xFFFFFFFF);
    final handleColor = isDarkMode ? Colors.grey[600]! : Colors.grey[300]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textSecondaryColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    final inputBgColor = isDarkMode
        ? const Color(0xFF1A1C20)
        : const Color(0xFFF9FAFB);
    final inputBorderColor = isDarkMode
        ? Colors.transparent
        : Colors.grey[200]!;
    final accentGreen = isDarkMode
        ? const Color(0xFF4ADE80)
        : Colors.green[600]!;
    final primaryOrange = const Color(0xFFFF4500);
    final chipSelectedBg = isDarkMode
        ? const Color(0xFF0F1114)
        : const Color(0xFF111827);
    final chipUnselectedBg = isDarkMode ? Colors.white : Colors.grey[100]!;

    return BlocConsumer<BetsPageBloc, BetsPageState>(
      listener: (context, state) {
        if (state is BetsPlaceSuccess) {
          Navigator.pop(context);
          context.read<UserPageBloc>().add(UserProfileByEmailEvent());
          context.read<BetsPageBloc>().add(BetsGetActiveEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Apuesta realizada con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is WithdrawBetSuccess) {
          Navigator.pop(context);
          context.read<UserPageBloc>().add(UserProfileByEmailEvent());
          context.read<BetsPageBloc>().add(BetsGetActiveEvent());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Apuesta retirada y dinero devuelto'),
              backgroundColor: Colors.blue,
            ),
          );
        } else if (state is BetsPageError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is BetsPageLoading;

        // --- LÓGICA DE VALIDACIÓN ---
        int currentBetAmount = 0;
        int? currentWinnerSelected;

        if (state is PreviousBetSuccess) {
          currentBetAmount = state.amount;
          currentWinnerSelected = state.winnerSelected;
        }

        // ¿Apostó por ESTE mismo equipo?
        bool hasBetOnThisTeam =
            currentWinnerSelected != null &&
            currentWinnerSelected == widget.teamId;
        // ¿Apostó por el OTRO equipo?
        bool hasBetOnOtherTeam =
            currentWinnerSelected != null &&
            currentWinnerSelected != widget.teamId;
        final totalStakeForProjection = hasBetOnThisTeam
          ? currentBetAmount + selectedAmount
          : selectedAmount;
        final basePotentialReturn = totalStakeForProjection * widget.odd;
        final premiumPotentialReturn = basePotentialReturn * _premiumMultiplier;
        final premiumExtra = premiumPotentialReturn - basePotentialReturn;
        // ----------------------------

        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: handleColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apuesta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  BlocBuilder<UserPageBloc, UserPageState>(
                    builder: (context, userState) {
                      String balance = "...";
                      if (userState is UserPageSuccess) {
                        balance =
                            "${userState.dto.balance?.toStringAsFixed(2)}€";
                      }
                      return Text(
                        balance,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: dividerColor, height: 1, thickness: 1),
              const SizedBox(height: 20),

              Text(
                '${widget.bet.team1?.name} — ${widget.bet.team2?.name}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),

              // --- ZONA DINÁMICA DE AVISOS ---
              if (hasBetOnThisTeam && currentBetAmount > 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ya tienes apostados ${currentBetAmount}€ a este equipo',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<BetsPageBloc>().add(
                                    WithdrawBetEvent(betId: widget.bet.id!),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.1),
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Retirar Apuesta',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (hasBetOnOtherTeam)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ya has apostado al otro equipo. No puedes apostar a ambos.',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Cargando datos...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

              if (isPremiumUser)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.withOpacity(0.45)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.workspace_premium_rounded,
                            size: 18,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Beneficio Premium x${_premiumMultiplier.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Si ganas, esta apuesta ascendería a '
                        '${premiumPotentialReturn.toStringAsFixed(2)}€ '
                        '(+${premiumExtra.toStringAsFixed(2)}€ extra).',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              if (hasBetOnThisTeam && currentBetAmount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Cálculo sobre total acumulado: ${currentBetAmount}€ + ${selectedAmount}€ = ${totalStakeForProjection}€',
                    style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              // ------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gana ${widget.teamSelected}',
                    style: TextStyle(fontSize: 14, color: textSecondaryColor),
                  ),
                  Text(
                    widget.odd.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        border: Border.all(color: inputBorderColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedAmount}€',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: textSecondaryColor,
                          ),
                          Text(
                            '${basePotentialReturn.toStringAsFixed(2)}€',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      // BLOQUEAMOS EL BOTÓN SI ESTÁ CARGANDO O SI YA APOSTÓ AL OTRO EQUIPO
                      onPressed: (isLoading || hasBetOnOtherTeam)
                          ? null
                          : () {
                              if (isPremiumUser) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Premium activo: retorno posible '
                                      '${premiumPotentialReturn.toStringAsFixed(2)}€ '
                                      '(x${_premiumMultiplier.toStringAsFixed(2)})',
                                    ),
                                    backgroundColor: Colors.amber[800],
                                  ),
                                );
                              }

                              final requestDto = PlaceBetRequestDto(
                                betId: widget.bet.id,
                                amount: selectedAmount,
                                winnerSelected: widget.teamId,
                                awarded: false,
                              );
                              context.read<BetsPageBloc>().add(
                                BetsPlaceEvent(dto: requestDto),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasBetOnOtherTeam
                            ? Colors.grey
                            : primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Apostar',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: presetAmounts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final amount = presetAmounts[index];
                    final isSelected = amount == selectedAmount;
                    return GestureDetector(
                      // BLOQUEAMOS LOS CHIPS SI YA APOSTÓ AL OTRO EQUIPO
                      onTap: (isLoading || hasBetOnOtherTeam)
                          ? null
                          : () => setState(() => selectedAmount = amount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? chipSelectedBg : chipUnselectedBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${amount}€',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
