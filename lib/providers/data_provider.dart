import 'dart:async';

import 'package:random/db/local.dart';
import 'package:random/models/dataModel.dart';
import 'package:flutter/material.dart';



class DataProvider extends ChangeNotifier {
  final _dataController = StreamController<List<DataModel>>.broadcast();

  Stream<List<DataModel>> get getDataStream => _dataController.stream;

  /// 新增的 controller
  final _insertController = StreamController<DataModel>.broadcast();

  /// 更新的 controller
  final _updateController = StreamController<DataModel>.broadcast();

  /// 刪除的 controller
  final _deleteController = StreamController<int>.broadcast();


  /// Sink
  StreamSink<DataModel> get insert => _insertController.sink;

  StreamSink<DataModel> get update => _updateController.sink;

  StreamSink<int> get delete => _deleteController.sink;

  /// 初始化
  DataProvider() {
    updateScreenData();
    _updateController.stream
        .listen((dataModel) => _handleUpdateData(dataModel));
    _insertController.stream.listen(( model) => _handleAddData( model));
    _deleteController.stream
        .listen((dataModel) => _handleDeleteData(dataModel));

  }
  /// 新增
  void _handleAddData( DataModel model) async {

    await AppDB.db.insertData(model);
    updateScreenData();
  }

  /// 更新
  void _handleUpdateData(DataModel dataModel) async {
    await AppDB.db.updateData(dataModel);
    updateScreenData();
  }

  /// 刪除
  void _handleDeleteData(int dataId) async {
    await AppDB.db.deleteData(dataId);
    updateScreenData();
  }

  /// 取得資料
  void updateScreenData() async {
    List<DataModel> data = await AppDB.db.getData();
    _dataController.sink.add(data);
  }

  @override
  void dispose() {
    _dataController.close();
    _insertController.close();
    _deleteController.close();
    _updateController.close();

    AppDB.db.close();
    super.dispose();
  }


}