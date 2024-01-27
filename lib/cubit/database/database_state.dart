part of 'database_cubit.dart';

@immutable
abstract class DatabaseState extends Equatable {}

class DatabaseInitial extends DatabaseState {
  @override
  List<Object?> get props => [];
}

/***
 * LOAD DB
 * Trigger saat loading mencari database
 */
class LoadDatabaseState extends DatabaseState{
  @override
  List<Object?> get props => [];
}
