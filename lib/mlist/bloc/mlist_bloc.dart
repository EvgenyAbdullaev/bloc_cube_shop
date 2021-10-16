import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shop_repository/shop_repository.dart';

part 'mlist_event.dart';
part 'mlist_state.dart';

class MlistBloc extends Bloc<MlistEvent, MlistState> {
  final ShopRepository repo;

  MlistBloc({required this.repo}) : super(MlistInitial()) {
    on<MlistEventInit>(_onInit);
    on<MlistEventLoad>(_onLoad);
    on<MlistEventDelete>(_onDelete);
    on<MlistEventAdd>(_onAdd);

  }

  void _onInit(MlistEvent event, Emitter<MlistState> emit) async {
    await repo.init();
    if (repo.data.isEmpty) {
      emit.call(MlistLoading());
    } else {
      emit.call(MlistLoaded());
    }
  }

  void _onLoad(MlistEvent event, Emitter<MlistState> emit) async {
    if (!repo.isLoading) {
      emit.call(MlistLoading());
      await repo.loadData();
      emit.call(MlistLoaded());
    }
  }

  void _onDelete(MlistEvent event, Emitter<MlistState> emit) async {
    emit.call(MlistDid());
    emit.call(MlistUpdate());
  }

  void _onAdd(MlistEvent event, Emitter<MlistState> emit) async {
    await repo.genRandomElem();
    emit.call(MlistDid());
    emit.call(MlistUpdate());
  }
}
