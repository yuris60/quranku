part of 'juz_cubit.dart';

abstract class JuzState extends Equatable {
  const JuzState();
}

class JuzInitial extends JuzState {
  @override
  List<Object?> get props => [];
}

/***
 * GET LIST JUZ
 * Trigger saat loading list juz pada Home Page
 */
class ListJuzInitial extends JuzState {
  @override
  List<Object?> get props => [];
}
class ListJuzLoading extends ListJuzInitial{}
class ListJuzSuccess extends ListJuzInitial{
  ListJuzSuccess(this.juzlist);
  final List<ListJuzModel> juzlist;

  List<Object?> get props => [juzlist];

}
