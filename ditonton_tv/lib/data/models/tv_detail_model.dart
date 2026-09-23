import 'package:ditonton_core/data/models/genre_model.dart';
import 'package:ditonton_core/domain/entities/season.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/data/models/season_model.dart';
import 'package:equatable/equatable.dart';
class TVDetailModel extends Equatable {
  const TVDetailModel({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.lastAirDate,
    required this.name,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String? lastAirDate;
  final String name;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalName;
  final String overview;
  final String? posterPath;
  final List<SeasonModel> seasons;
  final String? status;
  final String? tagline;
  final String? type;
  final double voteAverage;
  final int voteCount;

  factory TVDetailModel.fromJson(Map<String, dynamic> json) => TVDetailModel(
    backdropPath: json['backdrop_path'],
    firstAirDate: json['first_air_date'],
    genres: json['genres'] == null
        ? <GenreModel>[]
        : List<GenreModel>.from(
            (json['genres'] as List).map((x) => GenreModel.fromJson(x)),
          ),
    id: json['id'],
    lastAirDate: json['last_air_date'],
    name: json['name'] ?? '',
    numberOfEpisodes: json['number_of_episodes'] ?? 0,
    numberOfSeasons: json['number_of_seasons'] ?? 0,
    originalName: json['original_name'] ?? '',
    overview: json['overview'] ?? '',
    posterPath: json['poster_path'],
    seasons: json['seasons'] == null
        ? <SeasonModel>[]
        : List<SeasonModel>.from(
            (json['seasons'] as List).map((x) => SeasonModel.fromJson(x)),
          ),
    status: json['status'],
    tagline: json['tagline'],
    type: json['type'],
    voteAverage: json['vote_average'] == null
        ? 0.0
        : (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'backdrop_path': backdropPath,
    'first_air_date': firstAirDate,
    'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
    'id': id,
    'last_air_date': lastAirDate,
    'name': name,
    'number_of_episodes': numberOfEpisodes,
    'number_of_seasons': numberOfSeasons,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'seasons': List<dynamic>.from(seasons.map((x) => x.toJson())),
    'status': status,
    'tagline': tagline,
    'type': type,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TVDetail toEntity() {
    return TVDetail(
      backdropPath: backdropPath,
      firstAirDate: firstAirDate ?? '',
      genres: genres.map((e) => e.toEntity()).toList(),
      id: id,
      lastAirDate: lastAirDate,
      name: name,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      originalName: originalName,
      overview: overview,
      posterPath: posterPath ?? '',
      seasons: seasons
          .map(
            (e) => Season(
              airDate: e.airDate,
              episodeCount: e.episodeCount,
              id: e.id,
              name: e.name,
              overview: e.overview,
              posterPath: e.posterPath,
              seasonNumber: e.seasonNumber,
              voteAverage: e.voteAverage,
            ),
          )
          .toList(),
      status: status ?? '',
      tagline: tagline ?? '',
      type: type ?? '',
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genres,
    id,
    lastAirDate,
    name,
    numberOfEpisodes,
    numberOfSeasons,
    originalName,
    overview,
    posterPath,
    seasons,
    status,
    tagline,
    type,
    voteAverage,
    voteCount,
  ];
}
