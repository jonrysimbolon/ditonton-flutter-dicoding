import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/season_detail.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class GetSeasonDetail {
  final TVRepository repository;

  GetSeasonDetail(this.repository);

  Future<Either<Failure, SeasonDetail>> execute(int id, int seasonNumber) {
    return repository.getSeasonDetail(id, seasonNumber);
  }
}
