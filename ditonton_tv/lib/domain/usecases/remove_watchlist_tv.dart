import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class RemoveWatchlistTV {
  final TVRepository repository;

  RemoveWatchlistTV(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.removeWatchlist(tv);
  }
}
