import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TVModel extends Equatable {
  const TVModel({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final String? firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final List<String> originCountry;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  factory TVModel.fromJson(Map<String, dynamic> json) => TVModel(
    backdropPath: json['backdrop_path'],
    firstAirDate: json['first_air_date'],
    genreIds: json['genre_ids'] == null
        ? <int>[]
        : List<int>.from((json['genre_ids'] as List).map((x) => x)),
    id: json['id'],
    name: json['name'] ?? '',
    originCountry: json['origin_country'] == null
        ? <String>[]
        : List<String>.from((json['origin_country'] as List).map((x) => x)),
    originalName: json['original_name'] ?? '',
    overview: json['overview'] ?? '',
    popularity: json['popularity'] == null
        ? 0.0
        : (json['popularity'] as num).toDouble(),
    posterPath: json['poster_path'],
    voteAverage: json['vote_average'] == null
        ? 0.0
        : (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'backdrop_path': backdropPath,
    'first_air_date': firstAirDate,
    'genre_ids': List<dynamic>.from(genreIds.map((x) => x)),
    'id': id,
    'name': name,
    'origin_country': List<dynamic>.from(originCountry.map((x) => x)),
    'original_name': originalName,
    'overview': overview,
    'popularity': popularity,
    'poster_path': posterPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
  };

  TV toEntity() {
    return TV(
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      id: id,
      name: name,
      originCountry: originCountry,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genreIds,
    id,
    name,
    originCountry,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];
}
