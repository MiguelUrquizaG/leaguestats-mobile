import 'package:flutter/material.dart';

class PremiumSuccessPage extends StatelessWidget {
  const PremiumSuccessPage({super.key});

  String _formatSpanishDate(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final argsMap = routeArgs is Map<String, dynamic>
        ? routeArgs
        : <String, dynamic>{};

    final dynamic rawPrice = argsMap['price'];
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 4.00;

    final dynamic rawDate = argsMap['purchaseDate'];
    final purchaseDate = DateTime.tryParse(rawDate?.toString() ?? '') ??
      DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Glow Effect
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                // Blur effect will need ImageFilter or simply be an opaque glow
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Spacer for top alignment
                  const SizedBox(height: 40),

                  // Icon, Title, Subtitle
                  Column(
                    children: [
                      // Check Icon
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF007AFF,
                              ).withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 48,
                          weight: 800,
                        ),
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        '¡Ya eres Premium!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const Text(
                        'Gracias por suscribirte. Ahora tienes acceso ilimitado a todas las funciones.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(
                            0xFF94a3b8,
                          ), // slate-400 equivalent approx
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  // Plan Summary Card
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSummaryRow('Plan', 'Único'),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            _buildSummaryRow(
                              'Precio',
                              '${price.toStringAsFixed(2)} € (pago único)',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            _buildSummaryRow(
                              'Fecha de pago',
                              _formatSpanishDate(purchaseDate),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tu pago Premium se ha realizado correctamente y no se renovará automáticamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xFF64748b,
                          ), // slate-500 equivalent approx
                        ),
                      ),
                    ],
                  ),

                  // Bottom Actions
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigate back to home or relevant screen
                          Navigator.of(context).pushReplacementNamed('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: const Color(
                            0xFF007AFF,
                          ).withValues(alpha: 0.2),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Empezar a explorar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94a3b8), // slate-400 equivalent approx
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
