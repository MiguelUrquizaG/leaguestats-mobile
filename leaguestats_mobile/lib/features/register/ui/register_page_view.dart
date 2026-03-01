import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/services/auth_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/features/register/bloc/register_page_bloc.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  // No se necesitan controladores aquí

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? const Color(0xFF0F1115)
        : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E2128) : Colors.white;
    final textColor = isDark
        ? Colors.white
        : const Color(0xFF111827); // gray-900
    final subtitleColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280); // gray-400 : gray-500
    final primaryColor = const Color(0xFF8B00FF);

    return BlocProvider(
      create: (_) => RegisterPageBloc(AuthService(), StorageService()),
      child: BlocListener<RegisterPageBloc, RegisterPageState>(
        listener: (context, state) {
          if (state is RegisterPageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Registro exitoso',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushReplacementNamed(context, '/home');
            });
          } else if (state is RegisterPageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              // Background content
              Column(
                children: [
                  // Top half: Image with gradient
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCvOlcsOaqWQHMX_p28toJlFD3beUYMHwm-fNi7Wi_vfMxSsw8gLR2JNX_5FV8eUTpL4EZYeEv3tH0gGDkKqPsDAiQ0TVJs1pqFx3YqPTspXfugHcVExpTf9-VkqjpXpDQx7XXAhnEyvZK5_90D3JGtTtkZEaB1Ac0OT7iAlRlKxFcFlGIBspIDRouQbUlcarlhSTZMHtNhj7Ne_ke4cnQv8qsE45XB4pZsBxqsgcE9R4Nd1qWFTEE3yXCkMEN_E9ZruYU61i0b0os',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                        // Gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                backgroundColor.withValues(alpha: 0.0),
                                backgroundColor.withValues(alpha: 0.4),
                                backgroundColor.withValues(alpha: 1.0),
                              ],
                              stops: const [0.0, 0.5, 0.9],
                            ),
                          ),
                        ),
                        // Diamond icon at the bottom of the image section
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.string(
                                    '''
                                <svg fill="none" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                                  <path d="M50 20L20 50L50 80L80 50L50 20Z" stroke="white" stroke-linejoin="round" stroke-width="8"></path>
                                  <path d="M50 35L35 50L50 65L65 50L50 35Z" fill="white"></path>
                                </svg>
                                ''',
                                    width: 80,
                                    height: 80,
                                    // Apply drop shadow (approximate using color filter if needed, but not strictly necessary for simple SVG)
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom half: Form and buttons
                  Expanded(
                    child: Container(
                      color: backgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8), // Adjusted padding
                          // Title
                          Text(
                            'Enter the Arena',
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          // Subtitle
                          Text(
                            'Experience the next level of competitive gaming. Join the battle today.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: subtitleColor,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),

                          // Botón para ir a Login
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: primaryColor.withValues(alpha: 0.5),
                            ),
                            child: Text(
                              'Iniciar Sesión',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Botón para ir a la página de registro real
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/register_real',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Registrarse',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Home indicator mock
                          Container(
                            width: 128,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Top status bar overlay mock
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9:41',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.signal_cellular_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.wifi,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: 3.14159 / 2, // 90 degrees
                              child: const Icon(
                                Icons.battery_full,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
