import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class SearchTVs {
  final TVRepository repository;

  SearchTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
