part of 'surah_cubit.dart';

abstract class SurahState extends Equatable {}

class SurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}

class ListSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}

class ListSurahLoading extends ListSurahInitial{}

class ListSurahSuccess extends ListSurahInitial{
  final List<ListSurahModel> surahlist;
  ListSurahSuccess({
    required this.surahlist
  });
}

class BacaSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}

class BacaSurahLoading extends BacaSurahInitial{}

class BacaSurahSuccess extends BacaSurahInitial{
  final List<BacaSurahModel> surahbaca;
  final String id;
  BacaSurahSuccess({
    required this.surahbaca,
    required this.id
  });
}

class GetSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}

class GetSurahLoading extends GetSurahInitial{}

class GetSurahSuccess extends GetSurahInitial{
  final List<ListSurahModel> surahget;
  GetSurahSuccess({
    required this.surahget,
  });
}
