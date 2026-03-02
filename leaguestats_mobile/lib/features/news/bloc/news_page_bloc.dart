import 'package:bloc/bloc.dart';
import 'package:leaguestats_mobile/core/models/news/news_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/news_service.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';
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
  }
}
