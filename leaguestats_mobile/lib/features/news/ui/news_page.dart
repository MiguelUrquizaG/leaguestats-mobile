import 'package:flutter/material.dart';
import '../widget/news_card.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  static const kBackgroundColor = Color(0xFF1C1022);
  static const kPrimaryColor = Color(0xFFAD2BEE);
  static const kSurfaceColor = Color(0xFF2B1933);
  static const kInputColor = Color(0xFF3C2348);
  static const kNeutralColor = Color(0xFFB792C9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  NewsCard(
                    tag: 'LEC',
                    time: 'Hace 2 horas',
                    title: 'MKOI arrasa',
                    description:
                        'MAD Lions KOI domina la escena con una victoria histórica en la última jornada de la LEC contra G2.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAIT3CFcWy4EkTxBWZJsaOcNB561Nlbaa-DDoLmSQbmbqB9ZHMRo6ZKQ4CLKHwwDcMSortL4SvX4N3bx6uVTHfhSCK-dPa0bQZFVuEXVyN5SPI-w_SGUdZYCRdqClx2L0edYlpZpNSFpGvFIpmWeA1Qs7Q3UFxZSwjE6Xiha3Y5tCsl11CSbLzHEid463H6DGzSAMU-_FlKvSjMkyrNoKzLM0wN_Q12RVxwF0P6nE-2w3awsnFOSmrB82ZAonJRoePU1TTbZKJfvbY',
                    showReadMore: true,
                  ),
                  SizedBox(height: 16),
                  NewsCard(
                    tag: 'LCK',
                    time: 'Hace 5 horas',
                    title: 'Gen.G no sorprende',
                    description:
                        'Chovy mantiene su racha de victorias perfecta mientras Gen.G asegura su plaza en los playoffs.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAOlf31Kv_f3BtmQk_6TAoKPOEeI1kWIBGorjQOylF0O4n-yiHas2lr8LW20pNdtd8C8AUJRTD-p8oh2FhMEN69oWuFvIlUyTK5qg_zX_vyJiBETR3ftr7qqOn6Syj1LxGHhHMdWrw7XAMF9sxdshq8VHFZ_IXXF419qQuE_9ZEeP8eswqUPVgH60ldrY3mcG7Kzi8YMeF24WG-KsTHX79rDzsvrERgfuerTteWhTjlHCWZVUcrQsxAcj0GXfeVzCpHs3utrd-j4K0',
                  ),
                  SizedBox(height: 16),
                  NewsCard(
                    tag: 'Fichajes',
                    time: 'Hace 8 horas',
                    title: 'Fnatic busca refuerzos',
                    description:
                        'Rumores indican que el equipo europeo está en conversaciones con un nuevo jungla coreano.',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuArT3_nkef020PfOfIrZcTPOplFfotV0A94xistu9CEgmd1WFBX8CgE5lFJ7Y7Kkkiq_DyP9E8vecp9e42TwIFLpAYVkvkSjP4COykYeSbhm_Axr0cHCZHfyK_6zktg1AOWOeCejCyAeW5Cb4PFXRz9YRREAeMIgtglq1VYcx4hGcneLJCmoKnHp9bQgTXHG1e0DWe30s6Y3F_Met17IUSUuYpDFDe0pPzHsCaIu9Bj0U9QZtTQP3vSbrYoi6P1IN_cBs7Xq2oVPvI',
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: kNeutralColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: kInputColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: kNeutralColor, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Lexend',
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    cursorColor: kPrimaryColor,
                  ),
                ),
                const Icon(Icons.cancel, color: kNeutralColor, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['Competitivo', 'Transfer', 'Tutoriales', 'Skins'];
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kSurfaceColor, width: 1),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 24),
        itemBuilder: (context, index) {
          final isFirst = index == 0;
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isFirst ? kPrimaryColor : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isFirst ? Colors.white : kNeutralColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: kSurfaceColor,
          border: Border(
            top: BorderSide(color: kSurfaceColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.newspaper, 'Noticias', true),
            _buildNavItem(Icons.emoji_events, 'Resultados', false),
            _buildNavItem(Icons.groups, 'Equipos', false),
            _buildNavItem(Icons.person, 'Perfil', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? Colors.white : kNeutralColor),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kNeutralColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }
}
