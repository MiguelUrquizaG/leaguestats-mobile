import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/core/models/bets/bet_response_dto.dart';
import 'package:leaguestats_mobile/core/models/bets/place_bet_request_dto.dart';
import 'package:leaguestats_mobile/features/bets/bloc/bets_page_bloc.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart';

class BettingBottomSheetWidget extends StatefulWidget {
  final BetResponseDto bet;
  final String teamSelected;
  final double odd;
  // AÑADIDO: Necesitamos saber el ID del equipo ganador para el DTO
  final int teamId;

  const BettingBottomSheetWidget({
    super.key,
    required this.bet,
    required this.teamSelected,
    required this.odd,
    required this.teamId, // Añadido
  });

  @override
  State<BettingBottomSheetWidget> createState() =>
      _BettingBottomSheetWidgetState();
}

class _BettingBottomSheetWidgetState extends State<BettingBottomSheetWidget> {
  int selectedAmount = 200;
  final List<int> presetAmounts = [5, 20, 50, 100, 200, 500, 1000];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors based on design reference
    final sheetColor = isDarkMode
        ? const Color(0xFF23252B)
        : const Color(0xFFFFFFFF);
    final handleColor = isDarkMode ? Colors.grey[600]! : Colors.grey[300]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textSecondaryColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    final buttonBgColor = isDarkMode ? Colors.white : Colors.grey[100]!;
    final buttonIconColor = isDarkMode ? Colors.black : Colors.black87;
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
    final chipSelectedText = Colors.white;
    final chipUnselectedBg = isDarkMode ? Colors.white : Colors.grey[100]!;
    final chipUnselectedText = Colors.black87;

    // --- ENVOLVEMOS EL CONTENIDO EN EL BLOCCONSUMER ---
    return BlocConsumer<BetsPageBloc, BetsPageState>(
      listener: (context, state) {
        if (state is BetsPlaceSuccess) {
          Navigator.pop(context); // Cierra el modal

          // 1. Refresca el saldo
          context.read<UserPageBloc>().add(UserProfileByEmailEvent());

          // 2. ¡NUEVO! Refresca la lista de apuestas para que no se quede en blanco
          context.read<BetsPageBloc>().add(BetsGetActiveEvent());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Apuesta realizada con éxito!'),
              backgroundColor: Colors.green,
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
        // Variable para controlar si está cargando y desactivar botones
        final isLoading = state is BetsPageLoading;

        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
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

              // Header
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
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: buttonBgColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            size: 20,
                            color: buttonIconColor,
                          ),
                          onPressed: () {
                            // Lógica para añadir saldo (Modal fake o Stripe)
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // SALDO REAL DEL USUARIO OBTENIDO DEL BLOC
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
                ],
              ),
              const SizedBox(height: 20),

              // Divider
              Divider(color: dividerColor, height: 1, thickness: 1),
              const SizedBox(height: 20),

              // Match Info - AHORA DINÁMICO
              Text(
                '${widget.bet.team1?.name} — ${widget.bet.team2?.name}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.teamSelected} gana',
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

              // Input and Button
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
                          // CÁLCULO MATEMÁTICO DE LA GANANCIA
                          Text(
                            '${(selectedAmount * widget.odd).toStringAsFixed(2)}€',
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
                      // BLOQUEAMOS EL BOTÓN SI ESTÁ CARGANDO
                      onPressed: isLoading
                          ? null
                          : () {
                              // CREAMOS EL DTO
                              final requestDto = PlaceBetRequestDto(
                                betId: widget.bet.id,
                                amount: selectedAmount,
                                winnerSelected:
                                    widget.teamId, // ID del equipo seleccionado
                                awarded: false,
                              );

                              // ENVIAMOS EL EVENTO AL BLOC
                              context.read<BetsPageBloc>().add(
                                BetsPlaceEvent(dto: requestDto),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: primaryOrange.withValues(alpha: 0.2),
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
                              'Realizar Apuesta',
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

              // Chips
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
                    final text = amount >= 1000
                        ? '${(amount / 1000).toInt()}k€'
                        : '${amount}€';

                    return GestureDetector(
                      // DESACTIVAMOS TAP SI ESTÁ CARGANDO
                      onTap: isLoading
                          ? null
                          : () {
                              setState(() {
                                selectedAmount = amount;
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? chipSelectedBg : chipUnselectedBg,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? chipSelectedText
                                : chipUnselectedText,
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
