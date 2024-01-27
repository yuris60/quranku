part of 'surah_cubit.dart';

abstract class SurahState extends Equatable {}

class SurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}


/***
 * GET LIST SURAH
 * Trigger saat loading list surah pada Home Page
 */
class ListSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}
class ListSurahLoading extends ListSurahInitial{}
class ListSurahSuccess extends ListSurahInitial{
  ListSurahSuccess(this.surahlist);
  final List<ListSurahModel> surahlist;

  List<Object?> get props => [surahlist];
}

/***
 * GET SURAH (BY ID)
 * Trigger saat loading mencari data surah pada Surah Page
 */
class GetSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}
class GetSurahLoading extends GetSurahInitial{}

class GetSurahSuccess extends GetSurahInitial{
  GetSurahSuccess(this.surahget);
  final List<ListSurahModel> surahget;

  List<Object?> get props => [surahget];
}
