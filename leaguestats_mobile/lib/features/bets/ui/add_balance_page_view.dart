import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/features/user/bloc/user_page_bloc.dart'; 

class AddBalancePageView extends StatefulWidget {
  const AddBalancePageView({super.key});

  @override
  State<AddBalancePageView> createState() => _AddBalancePageViewState();
}

class _AddBalancePageViewState extends State<AddBalancePageView> {
  static const Color kPrimaryColor = Color(0xFF3B82F6);
  static const Color kSecondaryColor = Color(0xFF8B5CF6);
  static const Color kBackgroundDark = Color(0xFF0B0C10);
  static const Color kCardDark = Color(0xFF15161C);
  static const Color kCardBorder = Color(0xFF2A2C35);
  static const Color kInputDark = Color(0xFF1F2129);
  static const Color kTextMuted = Color(0xFF9CA3AF);

  final List<int> _presetAmounts = [10, 20, 50, 100];
  int? _selectedAmount = 50;
  final TextEditingController _amountController = TextEditingController(
    text: "50",
  );

  String _selectedPaymentMethod = "Credit Card";

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final value = int.tryParse(_amountController.text);
      if (value != null) {
        if (_presetAmounts.contains(value)) {
          setState(() {
            _selectedAmount = value;
          });
        } else {
          setState(() {
            _selectedAmount = null;
          });
        }
      } else {
        setState(() {
          _selectedAmount = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectPresetAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.value = TextEditingValue(
        text: amount.toString(),
        selection: TextSelection.collapsed(offset: amount.toString().length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double amountValue = double.tryParse(_amountController.text) ?? 0.0;
    final String displayAmount = "\$${amountValue.toStringAsFixed(2)}";

    return BlocConsumer<UserPageBloc, UserPageState>(
      listener: (context, state) {
        if (state is UserPageSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Pago realizado con éxito!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is UserAddBalanceError) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        
        final isLoading = state is UserPageLoading;

        return Scaffold(
          backgroundColor: kBackgroundDark,
          body: SafeArea(
            child: Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: isLoading
                              ? null
                              : () => Navigator.pop(
                                  context,
                                ), 
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kInputDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kCardBorder),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Añadir Saldo',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),

                        
                        Column(
                          children: [
                            Text(
                              'TU SALDO ACTUAL',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kTextMuted,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 8),

                            
                            Builder(
                              builder: (context) {
                                String balanceText = "\$0.00";
                                if (state is UserPageSuccess) {
                                  balanceText =
                                      "\$${state.dto.balance?.toStringAsFixed(2) ?? '0.00'}";
                                }
                                return Text(
                                  balanceText,
                                  style: GoogleFonts.inter(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        
                        Text(
                          'Seleccionar Monto',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: _presetAmounts.map((amount) {
                            final isSelected = _selectedAmount == amount;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: amount != _presetAmounts.last
                                      ? 12.0
                                      : 0.0,
                                ),
                                child: InkWell(
                                  onTap: isLoading
                                      ? null
                                      : () => _selectPresetAmount(amount),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? kSecondaryColor
                                          : kInputDark,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? kSecondaryColor
                                            : kCardBorder,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: kSecondaryColor
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '\$$amount',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(
                                                0xFFD1D5DB,
                                              ), 
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        
                        Container(
                          decoration: BoxDecoration(
                            color: kInputDark,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selectedAmount == null
                                  ? kSecondaryColor
                                  : kCardBorder,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '\$',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kTextMuted,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  enabled:
                                      !isLoading, 
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Ingresar otro monto',
                                    hintStyle: GoogleFonts.inter(
                                      color: kTextMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        
                        Text(
                          'Método de Pago',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextMuted,
                          ),
                        ),
                        const SizedBox(height: 16),

                        
                        _buildPaymentMethodOption(
                          title: "Credit Card",
                          subtitle: "**** 4432",
                          iconWidget: Container(
                            width: 40,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.credit_card,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                          isSelected: _selectedPaymentMethod == "Credit Card",
                          onTap: isLoading
                              ? () {}
                              : () {
                                  setState(() {
                                    _selectedPaymentMethod = "Credit Card";
                                  });
                                },
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethodOption(
                          title: "PayPal",
                          iconWidget: Container(
                            width: 40,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF003087),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Pay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Pal',
                                    style: TextStyle(color: Color(0xFF009cde)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          isSelected: _selectedPaymentMethod == "PayPal",
                          onTap: isLoading
                              ? () {}
                              : () {
                                  setState(() {
                                    _selectedPaymentMethod = "PayPal";
                                  });
                                },
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethodOption(
                          title: "Apple Pay",
                          iconWidget: Container(
                            width: 40,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Pay', 
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          isSelected: _selectedPaymentMethod == "Apple Pay",
                          onTap: isLoading
                              ? () {}
                              : () {
                                  setState(() {
                                    _selectedPaymentMethod = "Apple Pay";
                                  });
                                },
                        ),

                        const SizedBox(
                          height: 100,
                        ), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          bottomSheet: Container(
            color: kBackgroundDark.withValues(alpha: 0.95),
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              top: 16.0,
              bottom: 32.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comisión',
                      style: GoogleFonts.inter(fontSize: 14, color: kTextMuted),
                    ),
                    Text(
                      '\$0.00',
                      style: GoogleFonts.inter(fontSize: 14, color: kTextMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total a Pagar',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      displayAmount,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading || amountValue <= 0
                      ? null
                      : () {
                          
                          context.read<UserPageBloc>().add(
                            UserAddBalanceEvent(amount: amountValue),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: kSecondaryColor.withValues(alpha: 0.5),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.lock, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Confirmar Pago',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodOption({
    required String title,
    String? subtitle,
    required Widget iconWidget,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kCardDark : kInputDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? kSecondaryColor : kCardBorder),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kSecondaryColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kInputDark,
                border: Border.all(
                  color: isSelected
                      ? kSecondaryColor
                      : const Color(0xFF4B5563), 
                  width: isSelected ? 6 : 1,
                ),
              ),
            ),
            const SizedBox(width: 16),
            iconWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFD1D5DB), 
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(fontSize: 12, color: kTextMuted),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: kSecondaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}
