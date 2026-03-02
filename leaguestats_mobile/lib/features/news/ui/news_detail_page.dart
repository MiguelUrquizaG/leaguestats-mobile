import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';

class NewsDetailPage extends StatelessWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    // Definición de colores constantes
    const Color primaryColor = Color(0xFFAD2BEE);
    const Color backgroundColor = Color(0xFF050505);
    const Color textSecondary = Color(0xFF9CA3AF);

    // Creamos el Bloc y lanzamos la petición nada más entrar
    return BlocProvider(
      create: (context) =>
          NewsPageBloc(NewsService())..add(NewsGetById(id: newsId)),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: BlocBuilder<NewsPageBloc, NewsPageState>(
          builder: (context, state) {
            if (state is NewsPageLoading) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            if (state is NewsPageError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (state is NewsPageSingleSuccess) {
              final news = state.dto; // Tus datos reales vienen aquí

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Section Dinámico
                        _buildHeroSection(news, backgroundColor, primaryColor),

                        // Contenido del Artículo Dinámico
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryTags(news, primaryColor),
                              const SizedBox(height: 16),
                              Text(
                                news.title, // Título real
                                style: GoogleFonts.splineSans(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildAuthorInfo(news, primaryColor),
                              const SizedBox(height: 24),

                              // Descripción real del backend
                              Text(
                                news.description,
                                style: GoogleFonts.merriweather(
                                  color: textSecondary,
                                  fontSize: 16,
                                  height: 1.7,
                                ),
                              ),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTopNavigation(context),
                  _buildBottomBar(primaryColor),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  // --- Widgets Auxiliares con Datos Reales ---

  Widget _buildHeroSection(dynamic news, Color bgColor, Color primary) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Image.network(
            news.photo, // Imagen real
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, bgColor.withOpacity(0.8), bgColor],
                stops: const [0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTags(dynamic news, Color primary) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            news.type.toUpperCase(), // Tipo real (ej: "NOTICIA", "RESULTADO")
            style: GoogleFonts.splineSans(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthorInfo(dynamic news, Color primary) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: primary,
          child: const Icon(Icons.person, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              news.createdAt, // Fecha real
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    return Positioned(
      top: 48,
      left: 16,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color primary) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF121212).withOpacity(0.95),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.thumb_up_off_alt, color: Colors.grey),
                SizedBox(width: 8),
                Text('Me gusta', style: TextStyle(color: Colors.grey)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: const Text('Comentarios'),
            ),
          ],
        ),
      ),
    );
  }
}
