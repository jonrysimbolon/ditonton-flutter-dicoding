import 'package:ditonton_core/data/datasources/db/database_helper.dart';
import 'package:ditonton_tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton_tv/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';

import 'package:http/http.dart' as http;

@GenerateMocks(
  [TVRepository, TVRemoteDataSource, TVLocalDataSource, DatabaseHelper],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
