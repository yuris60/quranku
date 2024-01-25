part of 'juz_cubit.dart';

abstract class JuzState {}

class ListJuzInitial extends JuzState {}

class ListJuzLoading extends ListJuzInitial{}

class ListJuzSuccess extends ListJuzInitial{
  final List<ListJuzModel> listjuz;
  ListJuzSuccess({
    required this.listjuz
  });
}

class BacaJuzInitial extends JuzState {}

class BacaJuzLoading extends BacaJuzInitial{}

class BacaJuzSuccess extends BacaJuzInitial{
  final List<BacaJuzModel> bacajuz;
  BacaJuzSuccess({
    required this.bacajuz
  });
}
