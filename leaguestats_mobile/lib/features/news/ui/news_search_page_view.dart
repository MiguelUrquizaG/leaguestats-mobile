import 'package:flutter/material.dart';
import 'package:leaguestats_mobile/features/news/widget/news_detail_card.dart';

class NewsSearchPageView extends StatefulWidget {
  const NewsSearchPageView({super.key});

  @override
  State<NewsSearchPageView> createState() => _NewsSearchPageViewState();
}

class _NewsSearchPageViewState extends State<NewsSearchPageView> {
  String _selectedCategory = 'Competitivo';
  final TextEditingController _searchController = TextEditingController(
    text: 'E',
  );
  final List<String> _categories = [
    'Competitivo',
    'Transfer',
    'Tutoriales',
    'Skins',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF8E8A93),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Search Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF12121A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: const Color(0xFF7C3AED),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF8E8A93),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.cancel, color: Color(0xFF8E8A93)),
                      onPressed: () => _searchController.clear(),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category Tabs Section
            Container(
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF12121A), width: 1),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _categories.map((category) {
                    bool isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 24),
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected
                                  ? const Color(0xFF7C3AED)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF8E8A93),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Main Content Area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  NewsDetailCard(
                    imageUrl:
                        'https://cdn.sanity.io/images/dsfx7636/news/92a7400ec9ba59e10fc7241fc933ffc5829eeb2e-1600x900.jpg',
                    category: 'LEC',
                    time: 'Hace 2 horas',
                    title: 'MKOI arrasa',
                    description:
                        'MAD Lions KOI domina la escena con una victoria histórica en la última jornada de la LEC contra G2.',
                    showReadMore: true,
                  ),
                  NewsDetailCard(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAOlf31Kv_f3BtmQk_6TAoKPOEeI1kWIBGorjQOylF0O4n-yiHas2lr8LW20pNdtd8C8AUJRTD-p8oh2FhMEN69oWuFvIlUyTK5qg_zX_vyJiBETR3ftr7qqOn6Syj1LxGHhHMdWrw7XAMF9sxdshq8VHFZ_IXXF419qQuE_9ZEeP8eswqUPVgH60ldrY3mcG7Kzi8YMeF24WG-KsTHX79rDzsvrERgfuerTteWhTjlHCWZVUcrQsxAcj0GXfeVzCpHs3utrd-j4K0',
                    category: 'LCK',
                    time: 'Hace 5 horas',
                    title: 'Gen.G no sorprende',
                    description:
                        'Chovy mantiene su racha de victorias perfecta mientras Gen.G asegura su plaza en los playoffs.',
                  ),
                  NewsDetailCard(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuArT3_nkef020PfOfIrZcTPOplFfotV0A94xistu9CEgmd1WFBX8CgE5lFJ7Y7Kkkiq_DyP9E8vecp9e42TwIFLpAYVkvkSjP4COykYeSbhm_Axr0cHCZHfyK_6zktg1AOWOeCejCyAeW5Cb4PFXRz9YRREAeMIgtglq1VYcx4hGcneLJCmoKnHp9bQgTXHG1e0DWe30s6Y3F_Met17IUSUuYpDFDe0pPzHsCaIu9Bj0U9QZtTQP3vSbrYoi6P1IN_cBs7Xq2oVPvI',
                    category: 'Fichajes',
                    time: 'Hace 8 horas',
                    title: 'Fnatic busca refuerzos',
                    description:
                        'Rumores indican que el equipo europeo está en conversaciones con un nuevo jungla coreano.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
