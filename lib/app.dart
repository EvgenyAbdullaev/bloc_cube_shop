import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:google_fonts/google_fonts.dart';

import 'package:shop_repository/shop_repository.dart';

class ShopApp extends StatefulWidget {
  ShopApp({Key? key }) : super(key: key);

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late final ShopRepository _repo;

  @override
  void initState() {
    _repo = ShopRepository();
    _repo.init();

    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: testLoadData,
                  child: Text('load new data'),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: printLastURL,
                  child: Text('last url'),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: getMaxID,
                  child: Text('maxID'),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: genRandom,
                  child: Text('addRandom'),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: delFirst,
                  child: Text('delFirst'),
                ),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void testLoadData() {
    _repo.loadData();
    print('--- load data');
  }

  void getMaxID() {
    if (_repo.data.isNotEmpty) {
      print('--- maxLoadedID: ${_repo.maxLoadedIDTest}, length: ${_repo.data
          .length}');
    } else {
      print('--- maxLoadedID: ${_repo.maxLoadedIDTest}, empty list');
    }
  }

  void printLastURL() {
    if (_repo.data.isNotEmpty) {
      print('--- last id: ${_repo.data.last.id}, url: ${_repo.data.last.url}');
    } else {
      print('--- empty list');
    }
  }

  void genRandom() {
    _repo.genRandomElem();
    print('--- gen elem id: ${_repo.data.last.id}');
  }

  void delFirst() {
    if (_repo.data.isNotEmpty) {
      _repo.delElem(0);
      print('--- del first elem');
    } else {
      print('--- empty list');
    }
  }
}

