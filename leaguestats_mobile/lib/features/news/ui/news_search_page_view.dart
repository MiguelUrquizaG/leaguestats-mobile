import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';

class NewsSearchPageView extends StatefulWidget {
  const NewsSearchPageView({super.key});

  @override
  State<NewsSearchPageView> createState() => _NewsSearchPageViewState();
}

class _NewsSearchPageViewState extends State<NewsSearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  late final NewsPageBloc _newsPageBloc;

  @override
  void initState() {
    super.initState();
    _newsPageBloc = NewsPageBloc(NewsService())..add(NewsGetAllEvent());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _newsPageBloc.close();
    super.dispose();
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
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is NewsPageError) {
                      return Center(
                        child: Text(
                          'Error cargando noticias',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD1D5DB),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    if (state is NewsPageSuccess) {
                      final filteredNews = _filterNews(state.dto);

                      if (filteredNews.isEmpty) {
                        final hasQuery = _searchController.text.trim().isNotEmpty;
                        return Center(
                          child: Text(
                            hasQuery
                                ? 'No se encontraron noticias'
                                : 'No hay noticias disponibles',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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

  List<NewsResponseDto> _filterNews(List<NewsResponseDto> news) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return news;
    }

    return news.where((item) {
      return item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.type.toLowerCase().contains(query);
    }).toList();
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 24,
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
                  hintText: 'Buscar...',
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
          Text(
            'Cancelar',
            style: GoogleFonts.inter(
              color: const Color(0xFFD1D5DB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildTab('Competitivo', isSelected: true),
            const SizedBox(width: 24),
            _buildTab('Transfer', isSelected: false),
            const SizedBox(width: 24),
            _buildTab('Tutoriales', isSelected: false),
            const SizedBox(width: 24),
            _buildTab('Skins', isSelected: false),
            const SizedBox(width: 24),
            _buildTab('Patch Notes', isSelected: false),
          ],
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
    final typeLabel =
        news.type.trim().isNotEmpty ? news.type.toUpperCase() : 'NOTICIA';

    return Container(
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
            color: Colors.black.withValues(alpha: 0.5),
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
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: 16,
            child: Text(
              typeLabel,
              style: GoogleFonts.inter(
                fontSize: 100,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.05),
                letterSpacing: -5,
                height: 1,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Transform.rotate(
              angle: 1.5708,
              child: Text(
                typeLabel,
                style: GoogleFonts.inter(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF2DD4BF).withValues(alpha: 0.05),
                  letterSpacing: -4,
                  height: 1,
                ),
              ),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.3,
              child: Text(
                'NEWS',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
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
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
