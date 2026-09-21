import 'dart:convert';

import 'package:ditonton/common/api_config.dart';
import 'package:ditonton/common/server_exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/season_detail_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';

import 'package:http/http.dart' as http;

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  final http.Client client;

  TVRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVModel>> getAiringTodayTvs() async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/airing_today?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getOnTheAirTvs() async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/on_the_air?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getPopularTvs() async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/popular?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTopRatedTvs() async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/top_rated?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TVDetailModel> getTvDetail(int id) async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/$id?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> getTvRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/$id/recommendations?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<SeasonDetailModel> getSeasonDetail(int id, int seasonNumber) async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/tv/$id/season/$seasonNumber?api_key=$tmdbApiKey'),
    );
    if (response.statusCode == 200) {
      return SeasonDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVModel>> searchTvs(String query) async {
    final response = await client.get(
      Uri.parse('$tmdbBaseUrl/search/tv?api_key=$tmdbApiKey&query=$query'),
    );
    if (response.statusCode == 200) {
      return TVResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
