part of 'surah_cubit.dart';

abstract class SurahState {}

class SurahInitial extends SurahState {}

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
  final List<BacaSurahModel> surahbaca;
  BacaSurahSuccess({
    required this.surahbaca
  });
}

class GetSurahInitial extends SurahState {}

class GetSurahLoading extends GetSurahInitial{}

class GetSurahSuccess extends GetSurahInitial{
  final List<ListSurahModel> surahget;
  GetSurahSuccess({
    required this.surahget,
  });
}
