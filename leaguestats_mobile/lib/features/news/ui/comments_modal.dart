import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';

class CommentsModal extends StatelessWidget {
  final int newsId;

  const CommentsModal({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFAD2BEE);
    const Color backgroundColor = Color(0xFF050505);
    const Color textSecondary = Color(0xFF9CA3AF);

    return BlocProvider(
      create: (context) =>
          NewsPageBloc(NewsService())..add(NewsGetComments(id: newsId)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Encabezado del Modal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comentarios',
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Divider
            Container(
              height: 1,
              color: textSecondary.withOpacity(0.1),
            ),
            // Lista de Comentarios
            Expanded(
              child: BlocBuilder<NewsPageBloc, NewsPageState>(
                builder: (context, state) {
                  if (state is NewsCommentsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }

                  if (state is NewsCommentsPageError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  if (state is NewsCommentsSuccess) {
                    final comments = state.dto;

                    if (comments.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay comentarios aún',
                          style: GoogleFonts.merriweather(
                            color: textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return _buildCommentCard(
                          comment,
                          primaryColor,
                          textSecondary,
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(
    dynamic comment,
    Color primaryColor,
    Color textSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del comentario (usuario y fecha)
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: primaryColor,
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userProfile?.username ?? 'Usuario Anónimo',
                      style: GoogleFonts.splineSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      comment.createdAt ?? 'Hace poco',
                      style: GoogleFonts.merriweather(
                        color: textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Texto del comentario
          Text(
            comment.comment ?? '',
            style: GoogleFonts.merriweather(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Acciones (me gusta)
          Row(
            children: [
              Icon(Icons.thumb_up_off_alt,
                  size: 16, color: textSecondary.withOpacity(0.7)),
              const SizedBox(width: 4),
              Text(
                '${comment.likes ?? 0}',
                style: GoogleFonts.merriweather(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            color: textSecondary.withOpacity(0.1),
            height: 1,
          ),
        ],
      ),
    );
  }
}
