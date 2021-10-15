import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mlist_event.dart';
part 'mlist_state.dart';

class MlistBloc extends Bloc<MlistEvent, MlistState> {
  MlistBloc() : super(MlistInitial()) {
    on<MlistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
