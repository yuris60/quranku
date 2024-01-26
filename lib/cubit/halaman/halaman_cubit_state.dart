part of 'halaman_cubit.dart';

abstract class HalamanState extends Equatable {
  const HalamanState();
}

class HalamanInitial extends HalamanState {
  @override
  List<Object> get props => [];
}

class ListHalamanInitial extends HalamanState {
  @override
  List<Object?> get props => [];
}

class ListHalamanLoading extends ListHalamanInitial{}

class ListHalamanSuccess extends ListHalamanInitial{
  final List<ListHalamanModel> halamanlist;
  ListHalamanSuccess({
    required this.halamanlist
  });
}

class BacaHalamanInitial extends HalamanState {
  @override
  List<Object?> get props => [];
}

class BacaHalamanLoading extends BacaHalamanInitial{}

class BacaHalamanSuccess extends BacaHalamanInitial{
  final List<BacaHalamanModel> halamanbaca;
  BacaHalamanSuccess({
    required this.halamanbaca
  });
}
