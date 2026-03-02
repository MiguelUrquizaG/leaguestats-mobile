import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';
import 'package:leaguestats_mobile/features/news/ui/news_detail_page.dart';

class NewsSearchPageView extends StatefulWidget {
  const NewsSearchPageView({super.key});

  @override
  State<NewsSearchPageView> createState() => _NewsSearchPageViewState();
}

class _NewsSearchPageViewState extends State<NewsSearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  late final NewsPageBloc _newsPageBloc;

  // Estado para la pestaña seleccionada
  String _selectedTab = 'Todos';

  @override
  void initState() {
    super.initState();
    _newsPageBloc = NewsPageBloc(NewsService())..add(NewsGetAllEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {}); // Redibuja para filtrar mientras se escribe
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _newsPageBloc.close();
    super.dispose();
  }

  // Lógica de filtrado combinada (Búsqueda + Tipo)
  List<NewsResponseDto> _filterNews(List<NewsResponseDto> news) {
    final query = _searchController.text.trim().toLowerCase();

    return news.where((item) {
      // 1. Filtro por Pestaña (Mapeo a base de datos)
      bool matchesTab = true;
      if (_selectedTab != 'Todos') {
        final Map<String, String> typeMapping = {
          'Noticias': 'New',
          'Transfer': 'Transfer',
          'Tutoriales': 'Tutorial',
        };
        matchesTab = item.type == typeMapping[_selectedTab];
      }

      // 2. Filtro por consulta de búsqueda
      bool matchesQuery = true;
      if (query.isNotEmpty) {
        matchesQuery =
            item.title.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }

      return matchesTab && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      body: SafeArea(
        child: BlocProvider.value(
          value: _newsPageBloc,
          child: Column(
            children: [
              _buildTopBar(),
              _buildTabs(),
              Expanded(
                child: BlocBuilder<NewsPageBloc, NewsPageState>(
                  builder: (context, state) {
                    if (state is NewsPageInitial || state is NewsPageLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9333EA),
                        ),
                      );
                    }

                    if (state is NewsPageError) {
                      return Center(
                        child: Text(
                          'Error cargando noticias',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                      );
                    }

                    if (state is NewsPageSuccess) {
                      final filteredNews = _filterNews(state.dto);

                      if (filteredNews.isEmpty) {
                        return Center(
                          child: Text(
                            'No se encontraron resultados',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        itemCount: filteredNews.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          return _buildNewsCard(filteredNews[index]);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F23),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                cursorColor: const Color(0xFF9333EA),
                decoration: InputDecoration(
                  hintText: 'Buscar noticias...',
                  hintStyle: GoogleFonts.inter(color: const Color(0xFF6B7280)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _searchController.clear(),
            child: Text(
              'Limpiar',
              style: GoogleFonts.inter(
                color: const Color(0xFFD1D5DB),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final List<String> categories = [
      'Todos',
      'Noticias',
      'Transfer',
      'Tutoriales',
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: categories.map((name) {
            return Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = name),
                child: _buildTab(name, isSelected: _selectedTab == name),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTab(String text, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12, top: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color(0xFF9333EA) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isSelected ? const Color(0xFF9333EA) : const Color(0xFF9CA3AF),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsResponseDto news) {
    final imageUrl = news.photo.trim().isNotEmpty
        ? news.photo
        : 'https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg';
    final typeLabel = news.type.trim().isNotEmpty
        ? news.type.toUpperCase()
        : 'NOTICIA';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsId: news.id),
          ),
        );
      },
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF0A1A2F), Color(0xFF1A0B2E)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
            // Background decoration text
            Positioned(
              right: -20,
              top: 16,
              child: Text(
                typeLabel,
                style: GoogleFonts.inter(
                  fontSize: 100,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.05),
                  letterSpacing: -5,
                ),
              ),
            ),
            // Content
            Positioned(
              left: 20,
              top: 32,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD1D5DB),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Shaded Image overlay
            Positioned(
              right: -10,
              bottom: 0,
              width: 160,
              height: 190,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.9, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
