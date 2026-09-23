import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/failure.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';

class GetTVDetail {
  final TVRepository repository;

  GetTVDetail(this.repository);

  Future<Either<Failure, TVDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
