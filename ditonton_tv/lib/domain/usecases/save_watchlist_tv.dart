import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTV {
  final TVRepository repository;

  SaveWatchlistTV(this.repository);

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.saveWatchlist(tv);
  }
}
