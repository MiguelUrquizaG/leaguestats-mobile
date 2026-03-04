import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/core/services/settings_service.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final UserService _userService = UserService();
  final SettingsService _settingsService = SettingsService();

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isPremium = false;
  double _premiumPrice = 4.00;

  @override
  void initState() {
    super.initState();
    _loadPremiumData();
  }

  Future<void> _loadPremiumData() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _userService.getCurrentUserProfile();
      final price = await _settingsService.getPremiumPrice(fallback: 4.00);

      if (!mounted) return;
      setState(() {
        _isPremium = (profile.isPremium ?? 0) == 1;
        _premiumPrice = price;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _premiumPrice = 4.00;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _confirmPremiumDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text(
          'Confirmar pago',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Seguro que quieres convertirte en Premium por ${_premiumPrice.toStringAsFixed(2)}€ en un único pago?',
          style: const TextStyle(color: Color(0xFFcbd5e1)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1d72fe),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, continuar'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _subscribePremium() async {
    if (_isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ya eres Premium. No puedes volver a suscribirte.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final accepted = await _confirmPremiumDialog();
    if (!accepted) return;

    setState(() => _isSubmitting = true);

    try {
      await _userService.subscribeToPremium();

      if (!mounted) return;
      setState(() => _isPremium = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suscripción Premium activada correctamente.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacementNamed(
        '/premium_success',
        arguments: {
          'price': _premiumPrice,
          'purchaseDate': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al activar Premium: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0b),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF94a3b8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'LeagueStats Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Desbloquea todo el potencial de LeagueStats',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF94a3b8)),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBenefitItem('Mejores estadísticas'),
                    const SizedBox(height: 24),
                    _buildBenefitItem('Personalización del Perfil'),
                    const SizedBox(height: 24),
                    _buildBenefitItem('Sin anuncios'),
                    const SizedBox(height: 24),
                    _buildBenefitItem('Acceder a noticias antes'),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFF0f172a).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1d72fe), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1d72fe).withValues(alpha: 0.2),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PAGO ÚNICO',
                          style: TextStyle(
                            color: Color(0xFF1d72fe),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _premiumPrice.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1d72fe),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '€',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1d72fe),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isPremium
                              ? 'Ya tienes Premium activo'
                              : 'Cobro único',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94a3b8),
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: Color(0xFF1d72fe),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (_isLoading || _isSubmitting || _isPremium)
                    ? null
                    : _subscribePremium,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1d72fe),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF1d72fe).withValues(alpha: 0.5),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isPremium
                            ? 'Ya eres Premium'
                        : 'Suscríbete (${_premiumPrice.toStringAsFixed(2)}€ pago único)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sujeto a términos y condiciones. Pago único no recurrente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Color(0xFF64748b)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFF1d72fe),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFFe2e8f0),
          ),
        ),
      ],
    );
  }
}
