import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/news/comment_request_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_comment_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:meta/meta.dart';

part 'news_page_event.dart';
part 'news_page_state.dart';

class NewsPageBloc extends Bloc<NewsPageEvent, NewsPageState> {
  NewsPageBloc(NewsService newsService) : super(NewsPageInitial()) {
    on<NewsGetAllEvent>((event, emit) async {
      emit(NewsPageLoading());

      try {
        var newsResponse = await newsService.getAll();
        emit(NewsPageSuccess(dto: newsResponse));
      } catch (e) {
        emit(NewsPageError(message: e.toString()));
      }
    });
    on<NewsGetById>((event, emit) async {
      emit(NewsPageLoading());
      try {
        var news = await newsService.getById(event.id);
        emit(NewsPageSingleSuccess(dto: news));
      } catch (e) {
        emit(NewsPageError(message: e.toString()));
      }
    });
    on<NewsGetComments>((event, emit) async {
      emit(NewsCommentsLoading());

      try {
        var comments = await newsService.getNewsComments(event.id);
        emit(NewsCommentsSuccess(dto: comments));
      } catch (e) {
        emit(NewsCommentsPageError(message: e.toString()));
      }
    });
    on<NewsPostComment>((event, emit) async {
      emit(CommentLoading());

      try {
        await newsService.postComment(event.dto, event.idNews);
        emit(CommentSuccess());
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });

    on<NewsEditComment>((event, emit) async {
      emit(CommentLoading());
      try {
        await newsService.updateComment(event.dto, event.idNews);
        emit(CommentSuccess());
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });
    on<GetCommentsUserNews>((event, emit) async {
      emit(CommentLoading());
      try {
        var response = await newsService.findCommentsUserNew(event.idNews);
        emit(GetCommentsUserNewsSuccess(dto: response));
      } catch (e) {
        emit(NewsPageError(message: e.toString()));
      }
    });
    on<DeleteCommentUser>((event, emit) async {
      emit(CommentLoading());
      try {
        await newsService.deleteComment(event.idNews);
        emit(DeleteCommentSuccess());
      } catch (e) {
        emit(CommentError(message: e.toString()));
      }
    });
  }
}
