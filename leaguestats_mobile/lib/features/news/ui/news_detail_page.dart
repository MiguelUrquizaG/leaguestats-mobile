import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';
import 'package:leaguestats_mobile/features/news/ui/comments_modal.dart';

String _formatTimeAgo(String? dateString) {
  if (dateString == null || dateString.isEmpty) return 'Hace poco';
  
  try {
    final dateTime = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace ${weeks}w';
    }
  } catch (e) {
    return dateString;
  }
}

class NewsDetailPage extends StatelessWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    
    const Color primaryColor = Color(0xFFAD2BEE);
    const Color backgroundColor = Color(0xFF050505);
    const Color textSecondary = Color(0xFF9CA3AF);

    
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
              final news = state.dto; 

              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        _buildHeroSection(news, backgroundColor, primaryColor),

                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCategoryTags(news, primaryColor),
                              const SizedBox(height: 16),
                              Text(
                                news.title, 
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
                  _buildBottomBar(primaryColor, context),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  

  Widget _buildHeroSection(dynamic news, Color bgColor, Color primary) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: Image.network(
            news.photo, 
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
            news.type.toUpperCase(), 
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
              _formatTimeAgo(news.createdAt),
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

  Widget _buildBottomBar(Color primary, BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121212).withOpacity(0.98),
          border: Border(
            top: BorderSide(
              color: primary.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentsModal(
                        newsId: newsId,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary.withOpacity(0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Comentarios',
                          style: GoogleFonts.splineSans(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
