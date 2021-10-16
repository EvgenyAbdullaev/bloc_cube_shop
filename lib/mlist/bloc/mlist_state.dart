part of 'mlist_bloc.dart';

abstract class MlistState extends Equatable {
  @override
  List<Object> get props => [];

}

class MlistInitial extends MlistState { }

class MlistLoading extends MlistState { }

class MlistLoaded extends MlistState { }

class MlistDid extends MlistState { }

class MlistUpdate extends MlistState { }
