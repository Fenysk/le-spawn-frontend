import 'package:dartz/dartz.dart';

abstract class UpdateCheckerRepository {
  Future<Either<String, void>> checkForUpdate(String currentVersion);
}
