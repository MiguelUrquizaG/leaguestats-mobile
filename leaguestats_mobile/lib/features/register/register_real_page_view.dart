import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterRealPageView extends StatefulWidget {
  const RegisterRealPageView({super.key});

  @override
  State<RegisterRealPageView> createState() => _RegisterRealPageViewState();
}

class _RegisterRealPageViewState extends State<RegisterRealPageView> {
    bool _showPassword = false;
    bool _showRepeatPassword = false;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final primaryColor = const Color(0xFF6200EA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Image with Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://displays.riotgames.com/static/poster-dragontrainer-tristana-9d23667c8cc0d48758cc308119c43fd0.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
                  colorBlendMode: BlendMode.darken,
                ),
                // Gradient to blend image into background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                        backgroundColor,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Bar with Back Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      const Spacer(),
                      // Logo eliminado
                    ],
                  ),
                ),
                
                // Scrollable Form
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo eliminado

                          // Form Fields
                          _buildTextField(
                            label: 'Nombre',
                            hintText: 'Ejemplo: Raul',
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Email',
                            hintText: 'Ejemplo: raul@email.com',
                            keyboardType: TextInputType.emailAddress,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Contraseña',
                            hintText: 'Introduce tu contraseña',
                            obscureText: true,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Repita su contraseña',
                            hintText: 'Repite tu contraseña',
                            obscureText: true,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),

                          // Dropdowns
                          _buildDropdown(
                            label: 'País',
                            hint: 'Seleccionar País',
                            items: ['España', 'México', 'Argentina'],
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          _buildDropdown(
                            label: 'Equipo',
                            hint: 'Seleccionar Equipo',
                            items: ['Fnatic', 'G2 Esports', 'T1'],
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          _buildDropdown(
                            label: 'Liga',
                            hint: 'Seleccionar Liga',
                            items: ['LEC', 'LCS', 'LCK'],
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          
                          // Space to ensure bottom button doesn't cover content
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Fixed Button Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withValues(alpha: 0.0),
                    backgroundColor.withValues(alpha: 0.8),
                    backgroundColor,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: primaryColor.withValues(alpha: 0.4),
                ),
                child: Text(
                  'Crear cuenta',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    required Color labelColor,
    required Color surfaceColor,
    required Color textColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        StatefulBuilder(
          builder: (context, setFieldState) {
            bool isPasswordField = label.toLowerCase().contains('contraseña');
            bool showPassword = false;
            if (label.toLowerCase() == 'contraseña') {
              showPassword = _showPassword;
            } else if (label.toLowerCase().contains('repita')) {
              showPassword = _showRepeatPassword;
            }
            return TextFormField(
              obscureText: isPasswordField ? !showPassword : false,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(color: textColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(color: labelColor.withOpacity(0.6)),
                filled: true,
                fillColor: surfaceColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                suffixIcon: isPasswordField
                    ? IconButton(
                        icon: Icon(
                          showPassword ? Icons.visibility : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            if (label.toLowerCase() == 'contraseña') {
                              _showPassword = !_showPassword;
                            } else {
                              _showRepeatPassword = !_showRepeatPassword;
                            }
                          });
                          setFieldState(() {});
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required Color labelColor,
    required Color surfaceColor,
    required Color textColor,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          icon: Icon(Icons.expand_more, color: labelColor),
          hint: Text(hint, style: GoogleFonts.inter(color: textColor)),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.inter(color: textColor)),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}
