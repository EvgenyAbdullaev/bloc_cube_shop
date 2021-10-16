part of 'mlist_bloc.dart';

abstract class MlistEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MlistEventInit extends MlistEvent {}

class MlistEventLoad extends MlistEvent {}

class MlistEventDelete extends MlistEvent {}

class MlistEventAdd extends MlistEvent {}

