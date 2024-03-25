part of 'setting_cubit.dart';

sealed class SettingState extends Equatable {
  const SettingState();
}

class SettingInitial extends SettingState {

  @override
  List<Object?> get props => [];
}

/***
 * GET WAKTU SHALAT
 * Trigger saat memuat waktu shalat
 */
class SettingLoading extends SettingInitial{}
class SettingSuccess extends SettingInitial{
  SettingSuccess(this.waktushalat);
  final List<SettingModel> waktushalat;
  List<Object?> get props => [waktushalat];
}