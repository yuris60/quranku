part of 'waktu_shalat_cubit.dart';

abstract class WaktuShalatState extends Equatable {}

class WaktuShalatInitial extends WaktuShalatState {

  @override
  List<Object?> get props => [];
}

/***
 * GET WAKTU SHALAT
 * Trigger saat memuat waktu shalat
 */
class WaktuShalatLoading extends WaktuShalatInitial{}
class WaktuShalatSuccess extends WaktuShalatInitial{
  WaktuShalatSuccess(this.waktushalat);
  final List<WaktuShalatModel> waktushalat;
  List<Object?> get props => [waktushalat];
}

/***
 * SET STATUS SHALAT
 * Trigger saat mengklik memperbarui status shalat
 */
class StatusShalatLoading extends WaktuShalatInitial{}
class StatusShalatSuccess extends WaktuShalatInitial{
  final int waktushalat;
  StatusShalatSuccess(this.waktushalat);
  @override
  List<Object> get props => [waktushalat];
}
