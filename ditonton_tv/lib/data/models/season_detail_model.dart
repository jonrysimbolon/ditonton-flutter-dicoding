import 'package:ditonton_core/domain/entities/season_detail.dart';
import 'package:ditonton_tv/data/models/episode_model.dart';
import 'package:equatable/equatable.dart';
class SeasonDetailModel extends Equatable {
  const SeasonDetailModel({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? airDate;
  final List<EpisodeModel> episodes;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) =>
      SeasonDetailModel(
        airDate: json['air_date'],
        episodes: json['episodes'] == null
            ? <EpisodeModel>[]
            : List<EpisodeModel>.from(
                (json['episodes'] as List).map((x) => EpisodeModel.fromJson(x)),
              ),
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'air_date': airDate,
    'episodes': List<dynamic>.from(episodes.map((x) => x.toJson())),
    'id': id,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'season_number': seasonNumber,
  };

  SeasonDetail toEntity() {
    return SeasonDetail(
      airDate: airDate,
      episodes: episodes.map((e) => e.toEntity()).toList(),
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
    airDate,
    episodes,
    id,
    name,
    overview,
    posterPath,
    seasonNumber,
  ];
}
