part of 'mlist_bloc.dart';

abstract class MlistState extends Equatable {
  const MlistState();
}

class MlistInitial extends MlistState {
  @override
  List<Object> get props => [];
}
