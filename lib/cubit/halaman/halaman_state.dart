part of 'halaman_cubit.dart';

abstract class HalamanState extends Equatable {
  const HalamanState();
}

class HalamanInitial extends HalamanState {
  @override
  List<Object> get props => [];
}

/***
 * GET LIST HALAMAN
 * Trigger saat loading list halaman pada Home Page
 */
class ListHalamanInitial extends HalamanState {
  @override
  List<Object?> get props => [];
}
class ListHalamanLoading extends ListHalamanInitial{}
class ListHalamanSuccess extends ListHalamanInitial{
  ListHalamanSuccess(this.halamanlist);
  final List<ListHalamanModel> halamanlist;

  List<Object?> get props => [halamanlist];
}
