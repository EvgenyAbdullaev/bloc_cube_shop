import 'package:flutter/material.dart';

class GridElem extends StatelessWidget {
  const GridElem({Key? key,
    required this.title,
    required this.url,
    required this.index,
    required this.deleteSelf})
      : super(key: key);

  final String title;
  final String url;
  final int index;
  final void Function(int index) deleteSelf;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: GridTile(
        header: Align(
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            color: const Color(0xff2f54eb),
            child: IconButton(
              iconSize: 17,
              color: Colors.white,
              splashRadius: 1.0,
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                deleteSelf(index);
              },
            ),
          ),
          alignment: Alignment.topRight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                  url,
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              ),
              Positioned(
                bottom: 10,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}