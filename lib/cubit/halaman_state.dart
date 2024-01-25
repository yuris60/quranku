part of 'halaman_cubit.dart';

abstract class HalamanState {}

class ListHalamanInitial extends HalamanState {}

class ListHalamanLoading extends ListHalamanInitial{}

class ListHalamanSuccess extends ListHalamanInitial{
  final List<ListHalamanModel> listhalaman;
  ListHalamanSuccess({
    required this.listhalaman
  });
}

class BacaHalamanInitial extends HalamanState {}

class BacaHalamanLoading extends BacaHalamanInitial{}

class BacaHalamanSuccess extends BacaHalamanInitial{
  final List<BacaHalamanModel> bacahalaman;
  BacaHalamanSuccess({
    required this.bacahalaman
  });
}
