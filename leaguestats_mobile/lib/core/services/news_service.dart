import 'dart:convert';

import 'package:leaguestats_mobile/core/interfaces/news_interface.dart';
import 'package:http/http.dart' as http;
import 'package:leaguestats_mobile/core/models/news/comment_request_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_comment_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_list_response_dto.dart';
import 'package:leaguestats_mobile/core/models/news/news_response_dto.dart';
import 'package:leaguestats_mobile/core/services/storage_service.dart';

class NewsService implements NewsInterface {
  final String _apiUrl = "http://10.0.2.2:8000/api";
  final StorageService storage_service = StorageService();
  @override
  Future<List<NewsResponseDto>> getAll() async {
    print('SERVICIO');
    var _token = await storage_service.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/news'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
        'Accept': 'application/json',
      },
    );

    print(response.body);
    print(_token);

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var newsList = NewsResponseDto.fromJsonList(jsonDecode(response.body));
        print('CORRECTO');
        return newsList;
      } else {
        print('ERROR');
        throw Exception(response.body);
      }
    } catch (e) {
      print('ERROR 2');
      throw Exception(e.toString());
    }
  }

  @override
  Future<NewsResponseDto> getById(int id) async {
    var token = await storage_service.getToken();
    var response = await http.get(
      Uri.parse("$_apiUrl/news/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var news = NewsResponseDto.fromJson(jsonDecode(response.body));
        return news;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<NewsCommentResponseDto>> getNewsComments(int id) async {
    var token = await storage_service.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/news/$id/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        var commentsList = NewsCommentResponseDto.fromJsonList(
          jsonDecode(response.body),
        );
        return commentsList;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> postComment(CommentRequestDto dto, int idNews) async {
    var token = await storage_service.getToken();
    var response = await http.post(
      Uri.parse('$_apiUrl/news/$idNews/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateComment(CommentRequestDto dto, int idNews) async {
    var token = await storage_service.getToken();
    var response = await http.put(
      Uri.parse('$_apiUrl/news-comments/$idNews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dto.toJson()),
    );

    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    //Comentarios del usuario en esa noticia. /news/{newsId}/comments
  }

  @override
  Future<List<NewsCommentResponseDto>> findCommentsUserNew(int idNews) async {
    var token = await storage_service.getToken();
    var response = await http.get(
      Uri.parse('$_apiUrl/news/$idNews/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    try{
      if(response.statusCode>=200 && response.statusCode<300){
        var listComments = NewsCommentResponseDto.fromJsonList(jsonDecode(response.body));
        return listComments;
      }else{
        throw Exception(response.body);
      }
    }catch(e){
      throw Exception(e.toString());
    }
  }
}
