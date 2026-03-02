import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaguestats_mobile/features/bets/ui/bets_page_view.dart';
import 'package:leaguestats_mobile/features/login/bloc/login_page_bloc.dart';
import 'package:leaguestats_mobile/features/news/ui/news_search_page_view.dart';
import '../../home/ui/home_page_view.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
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
    const Color backgroundDark = Color(0xFF0F1115);
    const Color primaryColor = Color(0xFF5D12D2);
    const Color inputBg = Color(0xFF1E2128);

    const String logoSvg = '''
<svg fill="none" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
<path d="M50 15L85 50L50 85L15 50L50 15Z" stroke="white" stroke-linejoin="round" stroke-width="6"></path>
<path d="M50 35L65 50L50 65L35 50L50 35Z" fill="white"></path>
<path d="M50 28L72 50L50 72L28 50L50 28Z" stroke="white" stroke-width="2"></path>
</svg>
''';

    return BlocProvider(
      create: (_) => LoginPageBloc(AuthService(), StorageService()),
      child: BlocListener<LoginPageBloc, LoginPageState>(
        listener: (context, state) {
          if (state is LoginPageSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const BetsPageView()),
            );
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
          backgroundColor: backgroundDark,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // 1. IMAGEN DE FONDO
              Positioned(
                top: 0,
                left: -500,
                // Ajustamos la altura para que cubra más área pero se funda antes de los botones
                height: MediaQuery.of(context).size.height * 0.75,
                child: Image.network(
                  'https://4kwallpapers.com/images/walls/thumbs_3t/8373.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),

              // 2. GRADIENTE DE TRANSICIÓN MEJORADO
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      // Puntos de parada estratégicos para evitar cortes raros
                      stops: [0.0, 0.45, 0.85, 1.0],
                      colors: [
                        Colors
                            .black54, // Oscurece un poco arriba para el icono de atrás
                        Colors.transparent, // Deja la imagen clara en el centro
                        backgroundDark, // Fundido suave sobre los inputs
                        backgroundDark, // Fondo sólido al final
                      ],
                    ),
                  ),
                ),
              ),

              // 3. CONTENIDO PRINCIPAL
              SafeArea(
                child: Column(
                  children: [
                    // Icono de volver
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/register');
                          },
                        ),
                      ),
                    ),

                    // Logo centrado con resplandor
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.15),
                                blurRadius: 50,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: SvgPicture.string(logoSvg),
                        ),
                      ),
                    ),

                    // Sección inferior (Formulario y Botón)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildLabel('Email'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter your email",
                              hintStyle: const TextStyle(
                                color: Colors.white24,
                                fontSize: 15,
                              ),
                              filled: true,
                              fillColor: inputBg,
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

                          const SizedBox(height: 20),

                          _buildLabel('Contraseña'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              hintStyle: const TextStyle(
                                color: Colors.white24,
                                fontSize: 15,
                              ),
                              filled: true,
                              fillColor: inputBg,
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
                                  color: Colors.white24,
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
                              child: const Text(
                                '¿Has olvidado tu contraseña?',
                                style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Botón con sombra de color para evitar el efecto plano
                          BlocBuilder<LoginPageBloc, LoginPageState>(
                            builder: (context, state) {
                              return Container(
                                height: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: state is LoginPageLoading
                                      ? null
                                      : () {
                                          final email = _emailController.text
                                              .trim();
                                          final password = _passwordController
                                              .text
                                              .trim();
                                          if (email.isEmpty ||
                                              password.isEmpty) {
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
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state is LoginPageLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Iniciar Sesión',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          // Espacio para el indicador de inicio de sistema
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador inferior (Home Indicator)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 130,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
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

  // Helpers para limpieza de código
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  Widget _buildInput(
    String hint,
    Color bg, {
    bool isPass = false,
    Widget? suffix,
  }) {
    return TextField(
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 15),
        filled: true,
        fillColor: bg,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
