part of 'doa_cubit.dart';

abstract class DoaState extends Equatable {}

class DoaInitial extends DoaState {
  @override
  List<Object?> get props => [];
}

/***
 * GET LIST DOA
 * Trigger saat memuat doa-doa
 */
class ListDoaInitial extends DoaInitial {
  @override
  List<Object?> get props => [];
}
class ListDoaLoading extends ListDoaInitial{}
class ListDoaSuccess extends ListDoaInitial{
  ListDoaSuccess(this.listdoa);
  final List<ListDoaModel> listdoa;
  List<Object?> get props => [listdoa];
}

/***
 * SET STATUS BOOKMARK DOA
 * Trigger saat mengklik menandai doa
 */
class StatusBookmarkLoading extends ListDoaInitial{}
class StatusBookmarkSuccess extends ListDoaInitial{
  final int statusbookmark;
  StatusBookmarkSuccess(this.statusbookmark);
  @override
  List<Object> get props => [statusbookmark];
}