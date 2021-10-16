import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../mlist.dart';

class MlistGrid extends StatefulWidget {
  const MlistGrid({Key? key}) : super(key: key);

  @override
  _MlistGridState createState() => _MlistGridState();
}

class _MlistGridState extends State<MlistGrid> {
  final _scrollController = ScrollController();
  final _scrollBigController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollBigController.addListener(_onScrollBig);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        primary: false,
        controller: _scrollBigController,
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0.0,
            expandedHeight: 65,
            pinned: true,
            floating: true,
            toolbarHeight: 42.0,
            backgroundColor: Colors.black,
            title: const Text('Меню'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 10),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  color: const Color(0xff2f54eb),
                  child: IconButton(
                    iconSize: 17,
                    splashRadius: 1.0,
                    color: Colors.white,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addRandomElem();
                    },
                  ),
                ),
              ),
            ],
          ),

          BlocBuilder<MlistBloc, MlistState>(
            builder: (context, state) {
              if (state is MlistInitial) {
                context.read<MlistBloc>().add(MlistEventInit());
                return const SliverToBoxAdapter(
                  child: Center(child: Text('Инициализация'),),
                ) ;
              } else if (state is MlistLoading) {
                if (context.read<MlistBloc>().repo.data.isEmpty) {
                  context.read<MlistBloc>().add(MlistEventLoad());
                  return const SliverToBoxAdapter(child: BottomLoader());
                }
                return genGrid();
              } else if (state is MlistLoaded || state is MlistUpdate) {
                return genGrid();
              } else {
                return const SliverToBoxAdapter(child: BottomLoader());
              }
            },
          ),
        ]
      ),
    );

  }

  Widget genGrid() {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: context.read<MlistBloc>().repo.data.length,
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            final elem = context.read<MlistBloc>().repo.data
                .elementAt(index);
            return GridElem(
              title: elem.title,
              url: elem.url,
              index: index,
              deleteSelf: deleteElem,
            );
          }
      ),
    );
  }

  void deleteElem(int index) {
    context.read<MlistBloc>().repo.delElem(index);
    context.read<MlistBloc>().add(MlistEventDelete());
  }

  void addRandomElem() async {
    context.read<MlistBloc>().add(MlistEventAdd());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MlistBloc>().add(MlistEventLoad());
    }
  }

  void _onScrollBig() {
    if (!_scrollBigController.hasClients) return;

    if (_scrollBigController.offset > 0 &&
        context.read<MlistBloc>().repo.data.length < 10) {
      context.read<MlistBloc>().add(MlistEventLoad());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
