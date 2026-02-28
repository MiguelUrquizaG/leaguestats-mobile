import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStatWidget extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStatWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.splineSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.splineSans(
            fontSize: 10,
            color: const Color(0xFFA1A1AA), // text-sub
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
