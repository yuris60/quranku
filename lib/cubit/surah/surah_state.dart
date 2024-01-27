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

// class BacaSurahInitial extends SurahState {
//   @override
//   List<Object?> get props => [];
// }
//
// class BacaSurahLoading extends BacaSurahInitial{}
//
// class BacaSurahSuccess extends BacaSurahInitial{
//   BacaSurahSuccess(this.surahbaca);
//   final List<BacaSurahModel> surahbaca;
//   // BacaSurahSuccess({
//   //   required this.surahbaca
//   // });
//   List<Object?> get props => [surahbaca];
// }

class GetSurahInitial extends SurahState {
  @override
  List<Object?> get props => [];
}

class GetSurahLoading extends GetSurahInitial{}

class GetSurahSuccess extends GetSurahInitial{
  GetSurahSuccess(this.surahget);
  final List<ListSurahModel> surahget;
  // GetSurahSuccess({
  //   required this.surahget,
  // });
  List<Object?> get props => [surahget];
}
