part of 'baca_cubit.dart';

abstract class BacaState extends Equatable {}

class BacaInitial extends BacaState {
  @override
  List<Object?> get props => [];
}

/***
 * GET BACA SURAH
 * Trigger saat memuat ayat pada surah
 */
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

/***
 * GET LIST JUZ
 * Trigger saat memuat ayat pada juz
 */
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

/***
 * GET BACA HALAMAN
 * Trigger saat memuat ayat pada halaman
 */
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

/***
 * GET BACA DOA
 * Trigger saat memuat ayat pada doa
 */
class BacaDoaInitial extends BacaInitial {
  @override
  List<Object?> get props => [];
}
class BacaDoaLoading extends BacaDoaInitial{}
class BacaDoaSuccess extends BacaDoaInitial{
  BacaDoaSuccess(this.doabaca);
  final List<BacaDoaModel> doabaca;
  List<Object?> get props => [doabaca];
}

/***
 * GET RANDOM AYAT
 * Trigger saat memuat ayat pada halaman
 */
class RandomAyatInitial extends BacaInitial {
  @override
  List<Object?> get props => [];
}
class RandomAyatLoading extends RandomAyatInitial{}
class RandomAyatSuccess extends RandomAyatInitial{
  RandomAyatSuccess(this.ayatoftheday);
  final List<RandomAyatModel> ayatoftheday;
  List<Object?> get props => [ayatoftheday];
}

/***
 * GET KHATAM QURAN
 * Trigger saat loading menampilkan data Khatam Quran
 */
class KhatamQuranInitial extends BacaState {
  @override
  List<Object?> get props => [];
}
class KhatamQuranLoading extends KhatamQuranInitial{}

class KhatamQuranSuccess extends KhatamQuranInitial{
  KhatamQuranSuccess(this.khatamget);
  final List<KhatamQuranModel> khatamget;

  List<Object?> get props => [khatamget];
}

/***
 * SET STATUS KHATAM QURAN
 * Trigger saat menandai khatam quran
 */
class StatusKhatamLoading extends BacaInitial{}
class StatusKhatamSuccess extends BacaInitial{
  final int statuskhatam;
  StatusKhatamSuccess(this.statuskhatam);
  @override
  List<Object> get props => [statuskhatam];
}
