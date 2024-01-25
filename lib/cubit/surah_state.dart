part of 'surah_cubit.dart';

abstract class SurahState {}

class ListSurahInitial extends SurahState {}

class ListSurahLoading extends ListSurahInitial{}

class ListSurahSuccess extends ListSurahInitial{
  final List<ListSurahModel> surahlist;
  ListSurahSuccess({
    required this.surahlist
  });
}

class BacaSurahInitial extends SurahState {}

class BacaSurahLoading extends BacaSurahInitial{}

class BacaSurahSuccess extends BacaSurahInitial{
  final List<BacaSurahModel> surahlist;
  BacaSurahSuccess({
    required this.surahlist
  });
}

class GetSurahInitial extends SurahState {}

class GetSurahLoading extends GetSurahInitial{}

class GetSurahSuccess extends GetSurahInitial{
  final List<ListSurahModel> surahlist;
  GetSurahSuccess({
    required this.surahlist,
  });
}
