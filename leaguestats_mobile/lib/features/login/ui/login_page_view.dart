import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/features/login/bloc/login_page_bloc.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/models/auth/login_request_dto.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
      ? const Color(0xFF0F1115)
      : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E2128) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark
      ? const Color(0xFF9CA3AF)
      : const Color(0xFF6B7280);
    const Color primaryColor = Color(0xFF8B00FF);

    const String logoSvg = '''
<svg fill="none" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <path d="M50 20L20 50L50 80L80 50L50 20Z" stroke="black" stroke-linejoin="round" stroke-width="8"></path>
  <path d="M50 35L35 50L50 65L65 50L50 35Z" fill="black"></path>
</svg>
''';

    return BlocProvider(
      create: (_) =>
          LoginPageBloc(AuthService(), StorageService(), UserService()),
      child: BlocListener<LoginPageBloc, LoginPageState>(
        listener: (context, state) {
          if (state is LoginPageSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is LoginPageError) {
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
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://giffiles.alphacoders.com/220/220389.gif',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(color: Colors.black),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey[900]);
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                backgroundColor.withValues(alpha: 0.0),
                                backgroundColor.withValues(alpha: 0.45),
                                backgroundColor.withValues(alpha: 1.0),
                              ],
                              stops: const [0.0, 0.55, 0.92],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 42,
                          left: 10,
                          child: IconButton(
                            onPressed: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: SvgPicture.string(
                                logoSvg,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'LeagueStats',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Inicia sesión para seguir tus ligas, equipos y partidas favoritas.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: subtitleColor,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          _buildLabel('Email', subtitleColor),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: GoogleFonts.inter(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'tu@email.com',
                              hintStyle: GoogleFonts.inter(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: surfaceColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabel('Contraseña', subtitleColor),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            style: GoogleFonts.inter(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: GoogleFonts.inter(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: surfaceColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: subtitleColor,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                '¿Has olvidado tu contraseña?',
                                style: GoogleFonts.inter(
                                  color: subtitleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          BlocBuilder<LoginPageBloc, LoginPageState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: state is LoginPageLoading
                                    ? null
                                    : () {
                                        final email = _emailController.text
                                            .trim();
                                        final password = _passwordController
                                            .text
                                            .trim();
                                        if (email.isEmpty || password.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Completa ambos campos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        context.read<LoginPageBloc>().add(
                                          LoginEvent(
                                            dto: LoginRequestDto(
                                              email: email,
                                              password: password,
                                            ),
                                          ),
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                  shadowColor: primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                child: state is LoginPageLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Iniciar sesión',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/register_real',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: const BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Crear cuenta',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 128,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 100),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
