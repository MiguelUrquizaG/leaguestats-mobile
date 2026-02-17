import 'package:flutter/material.dart';

class ChampionDetailView extends StatefulWidget {
  const ChampionDetailView({super.key});

  @override
  State<ChampionDetailView> createState() => _ChampionDetailViewState();
}

class _ChampionDetailViewState extends State<ChampionDetailView> {
  int _selectedSkillIndex = 1; // Default to Q

  final List<Map<String, String>> _skills = [
    {
      'name': 'Pasiva',
      'key': 'PASIVA',
      'description': 'Ezreal gana velocidad de ataque cada vez que acierta una habilidad, acumulándose hasta 5 veces.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCbL3KAngJ_eXnMG3ble4J6pvkSwBtAaRazv5qzgNZSmq4ykMsf4TFsfo-rMSdkX3KkyXKjBJsgIIaQJ-N-UU0Wr-S1jglVmYiJ_qlgCbWv-K0aZJTnhLosgfl-2BsTZQC-MZCaPKiPPw8RJXUATSiaxZQD9uL3g6IwPxRGoQvtiw5ck0GiCtmO3Ogs51vLBRaYiVEW-zvefGtaqnpiLZKqHvrQV3vF1aQjZ2SoqWpqBeTb9KI5RWf0IkXjh9UKVVEd-QgMTbZRR9ES',
    },
    {
      'name': 'Disparo Místico',
      'key': 'TECLA Q',
      'description': 'Ezreal lanza un rayo de energía mística que reduce todos sus enfriamientos en 1.5 segundos si alcanza a una unidad enemiga. Aplica efectos de impacto.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAERgLF9XK3ArF1OEW-Ht7vVFj7G_kmh6K9ayu28uZT6xzYibUtnfLKsoNqAbI34VRM2ooTuUfNYkWe3L10WzzpPBKmTERymmVzssVkkoZ2Axb5eWdIrwcd-5N_6dnH1JBIzKMRVzuGQzI4_lL2KUwBUIY-XsiScZiMaMn2OrjmfjeKTHz2cgL-28BGJPgu0E_fud72q7ATw9UOfHK-co97VWfB2Rq4SgxMpGv2G3vfoe4f8e1FwPjQzrUn5FsTdzTzar6IfRXYd-hv',
    },
    {
      'name': 'Flujo de Esencia',
      'key': 'TECLA W',
      'description': 'Ezreal dispara un orbe que se adhiere al primer campeón u objetivo alcanzado. Si Ezreal golpea a un enemigo con el orbe, este detona y causa daño.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBpx-CmktwGPgkSAWKtsxgHZMIBCL5nZmUaSyw7fo7p2SlyW3xbgt-9xOmDWQFYkUhgQOa0ov0LqduWY8p5fs0vamE8w78L1tPflgg1QA_Sn1ofWhfxnweHi7LZKdknH3b8j09PA3vUylwo52iydx1diZlKt7_1t_QYRXwjhKTnrawBWsEh63BFaxY985421Uf41xKtgGp5EIYmQEmRMNxmRmCyg9wlZiOFT8t9eKkCydGgK9cf1nTPTr7HZjDN337C-FRXqh6Fj67u',
    },
    {
      'name': 'Desplazamiento Arcano',
      'key': 'TECLA E',
      'description': 'Ezreal se transporta a una ubicación cercana y dispara un rayo buscador a la unidad enemiga más próxima.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCQDtZhq117DuqdX7n5h_BxMiTed7KUuI9Wo-W5NmS5KKsWlsQWPLMD5BgOqRILXEPIimwzjNd953BZonx2iOURPzpZeRD7xQs-Iu4OhF9U2HBRQkfPRgo3TDTryxRGezEfGLNvbp1c2Fccbm7mzUCHTO87qQVlTyIJeeie95jnQZOoPjwXSa6lyezZ3j-hIxVCtgVQB4cFoenRvXJ_-ZFa_DaFNRdLiKtVWisjKtq-FTqFClcaji5EhsmJliHUb2HRQprq-K2Wo5UC',
    },
    {
      'name': 'Andanada Certera',
      'key': 'TECLA R',
      'description': 'Ezreal se prepara para disparar una potente ráfaga de proyectiles que infligen un gran daño a todos los enemigos que atraviesan.',
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBApBPFs10gdo5U37pXtDicmcVu_QJmTPBiTBPaOrtzUXIp83jE7vq_cWP34pT1T1-tfbU_zvIb8xvVgAj_Rnv8v8RZ0episoZAR2tmEo1R07wFDr3mdNZ179oiT3YlTlucpfuKSw9q4ALEs26H_Wl46L2gToth_gnqSKSu1wuu4gdfUPCyuars_W1iCvthKFamXUhlQVK0j_gqjbzQgp157q2Nz7Qdsf-hzAbC8QM5zSOsJpDSxqxURA35437-9JutKCZGtamWylxV',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF25D1F4);
    const backgroundColor = Color(0xFF101F22);
    const neutralDark = Color(0xFF1A2E32);
    const accentPurple = Color(0xFF7C3AED);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Stack(
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB-CHbXNMOCs0SD79On3WL5V6vvIQVq-Bzlfp14CF_pUbNhkhji5yX4hOX5EbI2tqEx9WqGcR7u08FHGedYwSCnVZhRy0AZ0nZRh8B7iGKZst8cG-Ml3Xh8MKf9QP1Y8vZn0UoZ29POsJjSLDQAriuNQpJiVl-3j14Q2AbNiOJFv7ubDMvDury-_WmMpigx4iX8NZ9gKawk0vyK73LR6wuGPfi_cKJ1zCWkKYRz9ek4kKkYEzrkZ_YTkwKwsHNmb48-Qq31NnmJWzYS',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor.withOpacity(0.2),
                        backgroundColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'EZREAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CAMPEÓN DE PILTOVER',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'EZREAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        '"El explorador prodigio"',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Biography
                  const _SectionHeader(title: 'BIOGRAFÍA'),
                  const SizedBox(height: 10),
                  Text(
                    'Un aventurero confiado con un talento crudo para las artes mágicas, Ezreal explora catacumbas perdidas, lidia con maldiciones antiguas y supera con facilidad las probabilidades más imposibles. Armado con un guantelete místico de Shurima, prefiere confiar en su ingenio y audacia antes que en los planes, disparando ráfagas de energía mágica a cualquiera que se interponga en su camino.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Skills
                  const _SectionHeader(title: 'HABILIDADES'),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_skills.length, (index) {
                        final isSelected = _selectedSkillIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSkillIndex = index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? primaryColor : Colors.white.withOpacity(0.2),
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: primaryColor.withOpacity(0.4),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : null,
                                    color: neutralDark,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      _skills[index]['imageUrl']!,
                                      width: index == _selectedSkillIndex ? 50 : 40,
                                      height: index == _selectedSkillIndex ? 50 : 40,
                                      fit: BoxFit.cover,
                                      color: isSelected ? null : Colors.white.withOpacity(0.6),
                                      colorBlendMode: isSelected ? null : BlendMode.modulate,
                                    ),
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Skill Detail Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.1),
                          accentPurple.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _skills[_selectedSkillIndex]['name']!.toUpperCase(),
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Text(
                                _skills[_selectedSkillIndex]['key']!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _skills[_selectedSkillIndex]['description']!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Stats & Meta Info
                  Row(
                    children: [
                      const Expanded(
                        child: _StatCard(
                          icon: Icons.track_changes,
                          label: 'ROL',
                          value: 'Tirador',
                          iconColor: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.bolt,
                          label: 'DIFICULTAD',
                          value: 'Fácil',
                          iconColor: accentPurple,
                          showDifficulty: true,
                          difficultyLevel: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Bottom Action
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: backgroundColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        shadowColor: primaryColor.withOpacity(0.5),
                      ),
                      child: const Text(
                        'CERRAR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF25D1F4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool showDifficulty;
  final int difficultyLevel;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.showDifficulty = false,
    this.difficultyLevel = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E32),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showDifficulty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: index < difficultyLevel
                                ? const Color(0xFF25D1F4)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
