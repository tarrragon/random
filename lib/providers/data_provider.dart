import 'dart:async';

import 'package:qi_keto/db/local.dart';
import 'package:qi_keto/models/alarmdataModel.dart';
import 'package:flutter/material.dart';



class AlarmProvider extends ChangeNotifier {
  final _alarmController = StreamController<List<AlarmDataModel>>.broadcast();

  Stream<List<AlarmDataModel>> get getAlarmStream => _alarmController.stream;

  /// 新增的 controller
  final _insertController = StreamController<AlarmDataModel>.broadcast();

  /// 更新的 controller
  final _updateController = StreamController<AlarmDataModel>.broadcast();

  /// 刪除的 controller
  final _deleteController = StreamController<int>.broadcast();


  /// Sink
  StreamSink<AlarmDataModel> get insert => _insertController.sink;

  StreamSink<AlarmDataModel> get update => _updateController.sink;

  StreamSink<int> get delete => _deleteController.sink;

  /// 初始化
  AlarmProvider() {
    updateScreenData();
    _updateController.stream
        .listen((alarmModel) => _handleUpdateAlarm(alarmModel));
    _insertController.stream.listen((alarmModel) => _handleAddAlarm(alarmModel));
    _deleteController.stream
        .listen((alarmModel) => _handleDeleteAlarm(alarmModel));

  }
  /// 新增
  void _handleAddAlarm(AlarmDataModel alarmModel) async {
    print("新增鬧鐘的provider");
    print(await AppDB.db.insertAlarm(alarmModel));
    updateScreenData();
  }

  /// 更新
  void _handleUpdateAlarm(AlarmDataModel alarmModel) async {
    await AppDB.db.updateAlarm(alarmModel);
    updateScreenData();
  }

  /// 刪除
  void _handleDeleteAlarm(int alarmid) async {
    await AppDB.db.deleteAlarm(alarmid);
    updateScreenData();
  }

  /// 取得資料
  void updateScreenData() async {
    List<AlarmDataModel> alarm = await AppDB.db.getAlarm();
    _alarmController.sink.add(alarm);
  }

  @override
  void dispose() {
    _alarmController.close();
    _insertController.close();
    _deleteController.close();
    _updateController.close();

    AppDB.db.close();
    super.dispose();
  }


}