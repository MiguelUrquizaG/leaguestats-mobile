import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFAD2BEE);
    const Color backgroundColor = Color(0xFF050505);
    const Color surfaceColor = Color(0xFF121212);
    const Color cardColor = Color(0xFF1E1E1E);
    const Color textPrimary = Color(0xFFF9FAFB);
    const Color textSecondary = Color(0xFF9CA3AF);
    const Color textMuted = Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Stack(
                  children: [
                    SizedBox(
                      height: 450,
                      width: double.infinity,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDePqYwZFlCWi8TQ-WcWsuEMg6dw3ikV-ttmV2n_xtvRA3uMDoHAWFgNvj7p1oOT-va8bZczj5izlPIramM3CdgGKU_gV1FkSoTpeGyo6j4KeEF7iF52KEfTs5h3yIkpmj8v6QCIN5gCVyipIK3t1iMdB_MxPsJyegZFnhAvS3UTuIdPHxEc1I6XqNkTZT-Ss3ri7sW0-VwPE3qD0ymFdop0ZQCZU9FraHsLY_e7o5C_fJqNiShE2nLRHucR8zrjk7RWlQaOM6JQH8',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[900],
                          child: const Icon(Icons.image, color: Colors.white, size: 100),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              backgroundColor.withOpacity(0.8),
                              backgroundColor,
                            ],
                            stops: const [0.6, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Team info on the left
                    Positioned(
                      top: 100,
                      left: 24,
                      child: Opacity(
                        opacity: 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 64,
                              width: 4,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 8),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                'MOVISTAR KOI',
                                style: GoogleFonts.splineSans(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // VS text in the middle
                    Positioned(
                      top: 150,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Center(
                              child: Text(
                                'LEC',
                                style: GoogleFonts.splineSans(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'VS',
                            style: GoogleFonts.splineSans(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 60,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Article Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'RESULTS',
                              style: GoogleFonts.splineSans(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Text(
                              'WEEK 3',
                              style: GoogleFonts.splineSans(
                                color: textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'MKOI arrasa en una partida decisiva contra Fnatic',
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: primaryColor, width: 2),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuAywld43d4RadvpDuV2TZWa8_g2mqHBQIAWvhYDBvZKIoMJenNuP2gNl_u2nVfq38lXH0kzSectljpHr3JqAFiococwvhPGPIWDj0er4FubenCSR3ELycZGlOQgBXqY9Semr2QZxYTB9J3nci5upnCckb_Ag4Ia74W44KjtZoY34aP55CdQqd2V-jIJDuHEhb76xVWGiiPkxlgAjfoQ_kNfU9CDsTlo2ugNTvsd2qquFsrRw0Z-h-9F2e8xduUpF57bj1SuEzlHi2s',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harry Harper',
                                  style: GoogleFonts.splineSans(
                                    color: textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Apr 12, 2023 · 4 min read',
                                  style: GoogleFonts.splineSans(
                                    color: textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Rich Text with Drop Cap
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'E',
                              style: GoogleFonts.merriweather(
                                color: primaryColor,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'l encuentro más esperado de la jornada no decepcionó. Movistar KOI (MKOI) demostró una superioridad táctica abrumadora frente a un Fnatic que no encontró respuestas en la Grieta del Invocador.',
                              style: GoogleFonts.merriweather(
                                color: textSecondary,
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.merriweather(
                            color: textSecondary,
                            fontSize: 16,
                            height: 1.6,
                          ),
                          children: [
                            const TextSpan(
                              text:
                                  'Desde el draft, se notó una preparación meticulosa por parte del cuerpo técnico de Ibai Llanos. La elección sorpresiva de ',
                            ),
                            TextSpan(
                              text: 'Sylas en la mid lane',
                              style: GoogleFonts.merriweather(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' desestabilizó por completo la composición de escalado que proponía Fnatic.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Dominio desde el Early Game',
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Forests are one of the most important natural resources that our planet possesses. Not only do they provide us with a diverse range of products such as timber, medicine, and food, but they also play a vital role in mitigating climate change and maintaining the overall health of our planet\'s ecosystems.',
                        style: GoogleFonts.merriweather(
                          color: textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Highlights Video Card
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuAxYSvrgEhirWwnMzNIWkkvfnaC9I7PhWyAyVhW8rS0r0sXk4wyMjPyk9SY5EDiiIPIYKQ4k58znz1Igy9rcYhhrWCCC6w3Q5-pSlYY4tXuFdNs5TxV3iaYA4rsLMs2nDjUL96XAgfONQhz20WL0ZMoUQHkMfpQbWWx7A3apJTmZvQ6iGpj9ld7DCrxHqPnso8mIjaKhvPfWSzoPoPTuOjvbPJ4HjFswlW5M5Kip99LIzQS-stgfhcbTBoH1bjoFjHV2zbABZ7XMuQ',
                            ),
                            fit: BoxFit.cover,
                            opacity: 0.9,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.play_circle_filled,
                                size: 64,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Highlights: Game 1',
                                  style: GoogleFonts.splineSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'In this article, we will explore the ways in which forests are helping our world. One of the most important roles that forests play is in absorbing carbon dioxide from the atmosphere. Trees absorb carbon dioxide during photosynthesis and store it in their biomass.',
                        style: GoogleFonts.merriweather(
                          color: textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Blockquote
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.3),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: const Border(
                            left: BorderSide(color: primaryColor, width: 4),
                          ),
                        ),
                        child: Text(
                          '"Hemos trabajado mucho la comunicación en las teamfights, y hoy se ha notado. Cada engage fue limpio." — Elyoya',
                          style: GoogleFonts.merriweather(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'El punto de inflexión',
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'La pelea por el Barón Nashor al minuto 24 fue el clavo en el ataúd. Un flanco perfecto de la toplane permitió a los carrys de MKOI limpiar la pelea sin sufrir bajas. Con el buff de Barón, la base de Fnatic cayó en cuestión de minutos.',
                        style: GoogleFonts.merriweather(
                          color: textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Next Up Section
                      Text(
                        'NEXT UP',
                        style: GoogleFonts.splineSans(
                          color: textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDI7BXNk8TzfNHZFlgzd4dlj0VUgJ7Qg9VeY1BjwL5ReM33dq_6_Mh6EberF9HXXMsu8yzq2LAiMOfa-_pBvhDY8m8b0T2fJCbTPaDk4WCAFhdcdw0LB8SF1b3WGejpk82kfXDx9V6UewEfSEsMy_M8aaG9uxx8aOdBZs1yiKkxkOB8YFmaf12kkzHt6472qoEucJ1lGEf4Y6-S4Jy39A0y2_qIRu-OCBd_xSzst77T_flAuJUx2pyNlcI-xd0BOaKIrREwbNxX0hg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INTERVIEW',
                                    style: GoogleFonts.splineSans(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Entrevista exclusiva: El camino a la final mundial',
                                    style: GoogleFonts.splineSans(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '2 hours ago',
                                    style: GoogleFonts.splineSans(
                                      color: textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // Padding for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Top Navigation
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.bookmark_border, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.share, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom Interaction Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: surfaceColor.withOpacity(0.9),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_off_alt, color: textSecondary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '1.2k',
                          style: GoogleFonts.splineSans(
                            color: textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 24),
                        const Icon(Icons.chat_bubble_outline, color: textSecondary, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '45',
                          style: GoogleFonts.splineSans(
                            color: textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Read Comments',
                        style: GoogleFonts.splineSans(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
