import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/auth/register_request_dto.dart';
import 'package:leaguestats_mobile/core/services/auth_service.dart';
import 'package:leaguestats_mobile/core/services/country_service.dart';
import 'package:leaguestats_mobile/core/services/league_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/core/services/team_service.dart';
import 'package:leaguestats_mobile/features/register/bloc/country_bloc.dart';
import 'package:leaguestats_mobile/features/leagues/bloc/league_bloc.dart';
import 'package:leaguestats_mobile/features/register/bloc/register_page_bloc.dart';
import 'package:leaguestats_mobile/features/teams/bloc/team_bloc.dart';

class RegisterRealPageView extends StatefulWidget {
  const RegisterRealPageView({super.key});

  @override
  State<RegisterRealPageView> createState() => _RegisterRealPageViewState();
}

class _RegisterRealPageViewState extends State<RegisterRealPageView> {
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedCountry;
  String? _selectedTeam;
  String? _selectedLeague;

  late final CountryBloc _countryBloc;
  late final TeamBloc _teamBloc;
  late final LeagueBloc _leagueBloc;
  late final RegisterPageBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _countryBloc = CountryBloc(CountryService())..add(LoadCountriesEvent());
    _teamBloc = TeamBloc(TeamService())..add(LoadTeamsEvent());
    _leagueBloc = LeagueBloc(LeagueService())..add(LoadLeaguesEvent());
    _registerBloc = RegisterPageBloc(AuthService(), StorageService());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _countryBloc.close();
    _teamBloc.close();
    _leagueBloc.close();
    _registerBloc.close();
    super.dispose();
  }

  void _submitRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int? countryId;
    if (_countryBloc.state is CountryLoaded && _selectedCountry != null) {
      final countries = (_countryBloc.state as CountryLoaded).countries;
      for (final country in countries) {
        if (country.name == _selectedCountry) {
          countryId = country.id;
          break;
        }
      }
    }

    int? teamId;
    if (_teamBloc.state is TeamLoaded && _selectedTeam != null) {
      final teams = (_teamBloc.state as TeamLoaded).teams;
      for (final team in teams) {
        if (team.name == _selectedTeam) {
          teamId = team.id;
          break;
        }
      }
    }

    int? leagueId;
    if (_leagueBloc.state is LeagueLoaded && _selectedLeague != null) {
      final leagues = (_leagueBloc.state as LeagueLoaded).leagues;
      for (final league in leagues) {
        if (league.name == _selectedLeague) {
          leagueId = league.id;
          break;
        }
      }
    }

    final dto = RegisterRequestDto(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword,
      countryId: countryId,
      teamId: teamId,
      leagueId: leagueId,
      banned: false,
      isPremium: false,
    );

    _registerBloc.add(RegisterEvent(dto: dto));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
      ? const Color(0xFF0F1115)
      : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1E2128) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final labelColor = isDark
      ? const Color(0xFFBFC8D0)
      : const Color(0xFF6B7280);
    final primaryColor = const Color(0xFF8B00FF);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _countryBloc),
        BlocProvider.value(value: _teamBloc),
        BlocProvider.value(value: _leagueBloc),
        BlocProvider.value(value: _registerBloc),
      ],
      child: BlocListener<RegisterPageBloc, RegisterPageState>(
        listener: (context, state) {
          if (state is RegisterPageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registro exitoso', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          } else if (state is RegisterPageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
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
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          'https://giffiles.alphacoders.com/222/222956.gif',
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
                                backgroundColor.withValues(alpha: 0.05),
                                backgroundColor.withValues(alpha: 0.55),
                                backgroundColor,
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 42,
                          left: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/register');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Crear cuenta',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Completa tu perfil para empezar a disfrutar de LeagueStats.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: labelColor,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTextField(
                            label: 'Nombre',
                            hintText: 'Ejemplo: Raul',
                            controller: _nameController,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Email',
                            hintText: 'Ejemplo: raul@email.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Contraseña',
                            hintText: 'Introduce tu contraseña',
                            controller: _passwordController,
                            obscureText: true,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Repita su contraseña',
                            hintText: 'Repite tu contraseña',
                            controller: _confirmPasswordController,
                            obscureText: true,
                            labelColor: labelColor,
                            surfaceColor: surfaceColor,
                            textColor: textColor,
                            primaryColor: primaryColor,
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<CountryBloc, CountryState>(
                            builder: (context, state) {
                              if (state is CountryLoading || state is CountryInitial) {
                                return _buildDropdown(
                                  label: 'País',
                                  hint: 'Cargando países...',
                                  items: const [],
                                  labelColor: labelColor,
                                  surfaceColor: surfaceColor,
                                  textColor: textColor,
                                  primaryColor: primaryColor,
                                );
                              }

                              if (state is CountryError) {
                                return _buildDropdown(
                                  label: 'País',
                                  hint: 'Error cargando países',
                                  items: const [],
                                  labelColor: labelColor,
                                  surfaceColor: surfaceColor,
                                  textColor: textColor,
                                  primaryColor: primaryColor,
                                );
                              }

                              final countries = (state as CountryLoaded)
                                  .countries
                                  .map((country) => country.name)
                                  .whereType<String>()
                                  .where((name) => name.trim().isNotEmpty)
                                  .toList();

                              final hasSelected =
                                  _selectedCountry != null && countries.contains(_selectedCountry);

                              return _buildDropdown(
                                label: 'País',
                                hint: countries.isEmpty
                                    ? 'No hay países disponibles'
                                    : 'Seleccionar país',
                                items: countries,
                                selectedValue: hasSelected ? _selectedCountry : null,
                                onChanged: countries.isEmpty
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedCountry = value;
                                        });
                                      },
                                labelColor: labelColor,
                                surfaceColor: surfaceColor,
                                textColor: textColor,
                                primaryColor: primaryColor,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<TeamBloc, TeamState>(
                            builder: (context, state) {
                              if (state is TeamLoading || state is TeamInitial) {
                                return _buildDropdown(
                                  label: 'Equipo',
                                  hint: 'Cargando equipos...',
                                  items: const [],
                                  labelColor: labelColor,
                                  surfaceColor: surfaceColor,
                                  textColor: textColor,
                                  primaryColor: primaryColor,
                                );
                              }

                              if (state is TeamError) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdown(
                                      label: 'Equipo',
                                      hint: 'Error cargando equipos',
                                      items: const [],
                                      labelColor: labelColor,
                                      surfaceColor: surfaceColor,
                                      textColor: textColor,
                                      primaryColor: primaryColor,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.message,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => context.read<TeamBloc>().add(
                                            LoadTeamsEvent(),
                                          ),
                                          child: const Text('Reintentar'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }

                              final teams = (state as TeamLoaded)
                                  .teams
                                  .map((team) => team.name)
                                  .whereType<String>()
                                  .where((name) => name.trim().isNotEmpty)
                                  .toList();

                              final hasSelected =
                                  _selectedTeam != null && teams.contains(_selectedTeam);

                              return _buildDropdown(
                                label: 'Equipo',
                                hint: teams.isEmpty
                                    ? 'No hay equipos disponibles'
                                    : 'Seleccionar equipo',
                                items: teams,
                                selectedValue: hasSelected ? _selectedTeam : null,
                                onChanged: teams.isEmpty
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedTeam = value;
                                        });
                                      },
                                labelColor: labelColor,
                                surfaceColor: surfaceColor,
                                textColor: textColor,
                                primaryColor: primaryColor,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<LeagueBloc, LeagueState>(
                            builder: (context, state) {
                              if (state is LeagueLoading || state is LeagueInitial) {
                                return _buildDropdown(
                                  label: 'Liga',
                                  hint: 'Cargando ligas...',
                                  items: const [],
                                  labelColor: labelColor,
                                  surfaceColor: surfaceColor,
                                  textColor: textColor,
                                  primaryColor: primaryColor,
                                );
                              }

                              if (state is LeagueError) {
                                return _buildDropdown(
                                  label: 'Liga',
                                  hint: 'Error cargando ligas',
                                  items: const [],
                                  labelColor: labelColor,
                                  surfaceColor: surfaceColor,
                                  textColor: textColor,
                                  primaryColor: primaryColor,
                                );
                              }

                              final leagues = (state as LeagueLoaded)
                                  .leagues
                                  .map((league) => league.name)
                                  .whereType<String>()
                                  .where((name) => name.trim().isNotEmpty)
                                  .toList();

                              final hasSelected =
                                  _selectedLeague != null && leagues.contains(_selectedLeague);

                              return _buildDropdown(
                                label: 'Liga',
                                hint: leagues.isEmpty
                                    ? 'No hay ligas disponibles'
                                    : 'Seleccionar liga',
                                items: leagues,
                                selectedValue: hasSelected ? _selectedLeague : null,
                                onChanged: leagues.isEmpty
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedLeague = value;
                                        });
                                      },
                                labelColor: labelColor,
                                surfaceColor: surfaceColor,
                                textColor: textColor,
                                primaryColor: primaryColor,
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          BlocBuilder<RegisterPageBloc, RegisterPageState>(
                            builder: (context, state) {
                              final isLoading = state is RegisterPageLoading;
                              return ElevatedButton(
                                onPressed: isLoading ? null : _submitRegister,
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
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Crear cuenta',
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
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              side: BorderSide(color: primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Ya tengo cuenta',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
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

  Widget _buildTextField({
    required String label,
    String? hintText,
    required TextEditingController controller,
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
            return Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
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
    String? selectedValue,
    ValueChanged<String?>? onChanged,
    required Color labelColor,
    required Color surfaceColor,
    required Color textColor,
    required Color primaryColor,
  }) {
    final dropdownColor = Color.alphaBlend(
      Colors.white.withOpacity(0.04),
      surfaceColor,
    );

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
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: labelColor.withOpacity(0.18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            isExpanded: true,
            menuMaxHeight: 280,
            dropdownColor: dropdownColor,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 1.6),
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: labelColor),
            hint: Text(
              hint,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: labelColor.withOpacity(0.85),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
