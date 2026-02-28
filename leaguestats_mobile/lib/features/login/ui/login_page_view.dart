import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

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

    return Scaffold(
      backgroundColor: backgroundDark,
      // Evita que el teclado empuje los elementos hacia arriba y rompa el gradiente
      resizeToAvoidBottomInset: false, 
      body: Stack(
        children: [
          // 1. IMAGEN DE FONDO
          Positioned(
            top: 0,
            left:-450,
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
                    Colors.black54,     // Oscurece un poco arriba para el icono de atrás
                    Colors.transparent, // Deja la imagen clara en el centro
                    backgroundDark,     // Fundido suave sobre los inputs
                    backgroundDark,     // Fondo sólido al final
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                      onPressed: () {},
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
                      _buildInput("Enter your email", inputBg),
                      
                      const SizedBox(height: 20),
                      
                      _buildLabel('Contraseña'),
                      const SizedBox(height: 8),
                      _buildInput("••••••••", inputBg, isPass: true, 
                        suffix: const Icon(Icons.visibility_off_outlined, color: Colors.white24, size: 20)),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('¿Has olvidado tu contraseña?', 
                            style: TextStyle(color: Colors.white30, fontSize: 12)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Botón con sombra de color para evitar el efecto plano
                      Container(
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
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Iniciar Sesión', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
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
    );
  }

  // Helpers para limpieza de código
  Widget _buildLabel(String text) => Text(text, 
      style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500));

  Widget _buildInput(String hint, Color bg, {bool isPass = false, Widget? suffix}) {
    return TextField(
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 15),
        filled: true,
        fillColor: bg,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}