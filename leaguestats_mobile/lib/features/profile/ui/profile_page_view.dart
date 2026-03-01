import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/user/user_response_dto.dart';
import 'package:leaguestats_mobile/core/services/user_service.dart';
import '../widget/profile_stat_widget.dart';
import '../widget/profile_info_item.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  late final Future<UserResponseDto> _userProfileFuture;

  static const Color kPrimaryColor = Color(0xFFA855F7);
  static const Color kBackgroundColor = Color(0xFF121214);
  static const Color kCardColor = Color(0xFF1E1E24);
  static const Color kTextSubColor = Color(0xFFA1A1AA);

  @override
  void initState() {
    super.initState();
    _userProfileFuture = UserService().getCurrentUserProfile();
  }

  String _safe(String? value, {String fallback = 'N/A'}) {
    final parsed = value?.trim();
    if (parsed == null || parsed.isEmpty) {
      return fallback;
    }
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: FutureBuilder<UserResponseDto>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error cargando perfil',
                    style: GoogleFonts.splineSans(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final profile = snapshot.data;
            final username =
                _safe(profile?.username ?? profile?.user?.name, fallback: 'Usuario');
            final email = _safe(profile?.user?.email, fallback: '@sin-email');
            final role = _safe(profile?.user?.role, fallback: 'Sin rol');
            final countryName = _safe(profile?.country?.name, fallback: 'Sin país');
            final countryCode = _safe(profile?.country?.flag, fallback: '--');
            final teamName = _safe(profile?.team?.name, fallback: 'Sin equipo');
            final premiumLabel = (profile?.isPremium == 1) ? 'Premium' : 'Free Member';

            return SingleChildScrollView(
              child: Column(
                children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: kCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                    ),
                    Text(
                      'Profile',
                      style: GoogleFonts.splineSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: kCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Avatar Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [kPrimaryColor, Colors.blue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: kBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDbd69pinRUZjVAe39nYqDKjIqqybaJrhjtozmJLyL6biHL6rVrfMe5at3YHqhWGH4jchHEDle6_fgJgT6FwGANag9CyoM-cLWjqV2MPA1_hq-HbfkI7MgpqJW3tyJlyGpfaqm1x_ZCrbdjMM7UvVM6rS9NG2EmDdQVHoC6qNQCEdW_zf1GE7_EK-3NeVkTTXP8DKRiGsOdPW3Y5qy-5wlPbTutJxUhZyxB-4szghgkEiZJf8jALQYF0AU_m1DU0scZBrlnHLdRSVg',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBackgroundColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: GoogleFonts.splineSans(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      email,
                      style: GoogleFonts.splineSans(
                        fontSize: 14,
                        color: kTextSubColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Text(
                        premiumLabel,
                        style: GoogleFonts.splineSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ProfileStatWidget(
                        value: (profile?.followers ?? 0).toString(),
                        label: 'Followers',
                      ),
                    ),
                    Container(width: 1, height: 32, color: Colors.white.withOpacity(0.1)),
                    Expanded(
                      child: ProfileStatWidget(
                        value: (profile?.balance ?? 0).toString(),
                        label: 'Balance',
                      ),
                    ),
                    Container(width: 1, height: 32, color: Colors.white.withOpacity(0.1)),
                    Expanded(
                      child: ProfileStatWidget(
                        value: (profile?.ratedMatches ?? 0).toString(),
                        label: 'Matches',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Edit Profile',
                          style: GoogleFonts.splineSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: kCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined, color: kTextSubColor),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Information list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INFORMATION',
                      style: GoogleFonts.splineSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: kTextSubColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProfileInfoItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Role',
                      value: role,
                    ),
                    ProfileInfoItem(
                      icon: Icons.groups_outlined,
                      title: 'Favorite Team',
                      value: teamName,
                    ),
                    ProfileInfoItem(
                      icon: Icons.favorite_border,
                      title: 'Username',
                      value: username,
                    ),
                    ProfileInfoItem(
                      icon: Icons.public,
                      title: 'Region',
                      value: '$countryName ($countryCode)',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
