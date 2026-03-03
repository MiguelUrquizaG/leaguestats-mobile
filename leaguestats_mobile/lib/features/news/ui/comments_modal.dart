import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaguestats_mobile/core/models/news/comment_request_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_comment_response_dto.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
import 'package:leaguestats_mobile/features/news/bloc/news_page_bloc.dart';

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

class CommentsModal extends StatefulWidget {
  final int newsId;

  const CommentsModal({
    super.key,
    required this.newsId,
  });

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final StorageService _storageService = StorageService();
  List<NewsCommentResponseDto> _comments = [];
  List<NewsCommentResponseDto> _userComments = [];
  bool _isFetchingComments = true;
  bool _isSendingComment = false;
  int? _editingCommentId;
  int? _deletingCommentId;
  String? _currentUserEmail;

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  bool _isUserComment(NewsCommentResponseDto comment) {
    final commentEmail = comment.userProfile?.user?.email;
    final currentEmail = _currentUserEmail;

    if (currentEmail != null && currentEmail.isNotEmpty) {
      return commentEmail != null &&
          commentEmail.toLowerCase() == currentEmail.toLowerCase();
    }

    final userIds = _userComments
        .map((userComment) => userComment.userId)
        .whereType<int>()
        .toSet();

    if (userIds.isEmpty || comment.userId == null) {
      return false;
    }

    return userIds.contains(comment.userId);
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUserEmail();
  }

  Future<void> _loadCurrentUserEmail() async {
    final email = await _storageService.getEmail();
    if (!mounted) return;

    _safeSetState(() {
      _currentUserEmail = email;
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendComment(BuildContext blocContext) {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty || _isSendingComment) {
      return;
    }

    setState(() {
      _isSendingComment = true;
      _editingCommentId = null;
    });

    blocContext.read<NewsPageBloc>().add(
      NewsPostComment(
        dto: CommentRequestDto(comment: commentText),
        idNews: widget.newsId,
      ),
    );
  }

  void _editComment(
    BuildContext blocContext,
    NewsCommentResponseDto comment,
    String updatedComment,
  ) {
    final commentId = comment.id;
    if (commentId == null || _isSendingComment) {
      return;
    }

    setState(() {
      _isSendingComment = true;
      _editingCommentId = commentId;
    });

    blocContext.read<NewsPageBloc>().add(
      NewsEditComment(
        dto: CommentRequestDto(comment: updatedComment),
        idNews: commentId,
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext blocContext,
    NewsCommentResponseDto comment,
  ) async {
    final controller = TextEditingController(text: comment.comment ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Editar comentario',
            style: GoogleFonts.splineSans(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 4,
            minLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Actualiza tu comentario...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0x33FFFFFF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFAD2BEE)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedText = controller.text.trim();
                if (updatedText.isEmpty) {
                  return;
                }
                Navigator.of(dialogContext).pop();
                _editComment(blocContext, comment, updatedText);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteComment(BuildContext blocContext, NewsCommentResponseDto comment) {
    final commentId = comment.id;
    if (commentId == null || _isSendingComment) {
      return;
    }

    _safeSetState(() {
      _isSendingComment = true;
      _deletingCommentId = commentId;
      _editingCommentId = null;
    });

    blocContext.read<NewsPageBloc>().add(
      DeleteCommentUser(idNews: commentId),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext blocContext,
    NewsCommentResponseDto comment,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: Text(
            'Eliminar comentario',
            style: GoogleFonts.splineSans(color: Colors.white),
          ),
          content: Text(
            '¿Seguro que quieres eliminar este comentario?',
            style: GoogleFonts.merriweather(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteComment(blocContext, comment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFAD2BEE);
    const Color backgroundColor = Color(0xFF050505);
    const Color textSecondary = Color(0xFF9CA3AF);

    return BlocProvider(
      create: (context) =>
          NewsPageBloc(NewsService())
            ..add(NewsGetComments(id: widget.newsId))
            ..add(GetCommentsUserNews(idNews: widget.newsId)),
      child: BlocConsumer<NewsPageBloc, NewsPageState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is NewsCommentsLoading && _comments.isEmpty) {
            _safeSetState(() {
              _isFetchingComments = true;
            });
          }

          if (state is NewsCommentsSuccess) {
            _safeSetState(() {
              _comments = state.dto;
              _isFetchingComments = false;
            });
          }

          if (state is CommentSuccess) {
            final wasEditing = _editingCommentId != null;
            _safeSetState(() {
              _isSendingComment = false;
              _editingCommentId = null;
              _deletingCommentId = null;
            });

            if (!wasEditing) {
              _commentController.clear();
            }

            FocusScope.of(context).unfocus();
            context.read<NewsPageBloc>().add(NewsGetComments(id: widget.newsId));
            context.read<NewsPageBloc>().add(GetCommentsUserNews(idNews: widget.newsId));
          }

          if (state is DeleteCommentSuccess) {
            _safeSetState(() {
              _isSendingComment = false;
              _deletingCommentId = null;
              _editingCommentId = null;
            });

            context.read<NewsPageBloc>().add(NewsGetComments(id: widget.newsId));
            context.read<NewsPageBloc>().add(GetCommentsUserNews(idNews: widget.newsId));
          }

          if (state is CommentError) {
            _safeSetState(() {
              _isSendingComment = false;
              _editingCommentId = null;
              _deletingCommentId = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is NewsCommentsPageError) {
            _safeSetState(() {
              _isFetchingComments = false;
            });
          }

          if (state is GetCommentsUserNewsSuccess) {
            _safeSetState(() {
              _userComments = state.dto;
            });
          }
        },
        builder: (context, state) => AnimatedPadding(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white.withOpacity(0.1),
                ),
                // Lista de Comentarios
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (_isFetchingComments) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }

                      if (state is NewsCommentsPageError && _comments.isEmpty) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (_comments.isEmpty) {
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          final canEdit = _isUserComment(comment);
                          return _buildCommentCard(
                            context,
                            comment,
                            primaryColor,
                            textSecondary,
                            canEdit: canEdit,
                          );
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendComment(context),
                            decoration: InputDecoration(
                              hintText: 'Escribe un comentario...',
                              hintStyle: TextStyle(
                                color: textSecondary.withOpacity(0.9),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: _isSendingComment
                                ? null
                                : () => _sendComment(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: primaryColor.withOpacity(0.5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: _isSendingComment
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Enviar',
                                    style: GoogleFonts.splineSans(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentCard(
    BuildContext blocContext,
    NewsCommentResponseDto comment,
    Color primaryColor,
    Color textSecondary,
    {required bool canEdit}
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del comentario (usuario y fecha)
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.person, size: 20, color: Colors.white),
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(comment.createdAt),
                        style: GoogleFonts.merriweather(
                          color: textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (canEdit)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _isSendingComment
                            ? null
                            : () => _showEditDialog(blocContext, comment),
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: primaryColor,
                        ),
                        tooltip: 'Editar comentario',
                      ),
                      IconButton(
                        onPressed: _isSendingComment
                            ? null
                            : () => _showDeleteDialog(blocContext, comment),
                        icon: comment.id == _deletingCommentId && _isSendingComment
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Colors.redAccent,
                              ),
                        tooltip: 'Eliminar comentario',
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 14),
            // Texto del comentario
            Text(
              comment.comment ?? '',
              style: GoogleFonts.merriweather(
                color: Colors.white,
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 14),
            // Botón Me Gusta mejorado
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        size: 16,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${comment.likes ?? 0}',
                        style: GoogleFonts.splineSans(
                          color: primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
