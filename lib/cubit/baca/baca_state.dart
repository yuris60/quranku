part of 'baca_cubit.dart';

abstract class BacaState extends Equatable {}

class BacaInitial extends BacaState {
  @override
  List<Object?> get props => [];
}

class BacaSurahInitial extends BacaInitial {
  @override
  List<Object?> get props => [];
}
class BacaSurahLoading extends BacaSurahInitial{}
class BacaSurahSuccess extends BacaSurahInitial{
  BacaSurahSuccess(this.surahbaca);
  final List<BacaSurahModel> surahbaca;
  List<Object?> get props => [surahbaca];
}


class BacaJuzInitial extends BacaInitial {
  @override
  List<Object?> get props => [];
}
class BacaJuzLoading extends BacaJuzInitial{}
class BacaJuzSuccess extends BacaJuzInitial{
  BacaJuzSuccess(this.juzbaca);
  final List<BacaJuzModel> juzbaca;
  List<Object?> get props => [juzbaca];
}


class BacaHalamanInitial extends BacaInitial {
  @override
  List<Object?> get props => [];
}
class BacaHalamanLoading extends BacaHalamanInitial{}
class BacaHalamanSuccess extends BacaHalamanInitial{
  BacaHalamanSuccess(this.halamanbaca);
  final List<BacaHalamanModel> halamanbaca;
  List<Object?> get props => [halamanbaca];
}
