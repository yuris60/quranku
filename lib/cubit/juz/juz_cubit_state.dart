part of 'juz_cubit.dart';

abstract class JuzState extends Equatable {
  const JuzState();
}

class JuzInitial extends JuzState {
  @override
  List<Object?> get props => [];
}

class ListJuzInitial extends JuzState {
  @override
  List<Object?> get props => [];
}

class ListJuzLoading extends ListJuzInitial{}

class ListJuzSuccess extends ListJuzInitial{
  final List<ListJuzModel> juzlist;
  ListJuzSuccess({
    required this.juzlist
  });
}

class BacaJuzInitial extends JuzState {
  @override
  List<Object?> get props => [];
}

class BacaJuzLoading extends BacaJuzInitial{}

class BacaJuzSuccess extends BacaJuzInitial{
  final List<BacaJuzModel> juzbaca;
  BacaJuzSuccess({
    required this.juzbaca
  });
}
