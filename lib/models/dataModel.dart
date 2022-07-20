import 'dart:convert';

class AlarmDataModel{
  int? alarmid;
  int hour;
  int minute;
  int mon;
  int tues;
  int wed;
  int thur;
  int fri;
  int sat;
  int sun;
  String ringtone;
  int repeat;


  AlarmDataModel({
    this.alarmid,
    required this.hour,
    required this.minute,
    required this.mon,
    required this.tues,
    required this.wed,
    required this.thur,
    required this.fri,
    required this.sat,
    required this.sun,
    required this.ringtone,
    required this.repeat,
  });


  factory AlarmDataModel.fromJson(Map<String,dynamic> parsedJson){
    return AlarmDataModel(
      alarmid : parsedJson['id'],
      hour : parsedJson['hour'],
      minute : parsedJson['minute'],
      mon : parsedJson['mon'],
      tues : parsedJson['tues'],
      wed : parsedJson['wed'],
      thur : parsedJson['thur'],
      fri : parsedJson['fri'],
      sat : parsedJson['sat'],
      sun : parsedJson['sun'],
      ringtone : parsedJson['ringtone'],
      repeat : parsedJson['repeat'],
    );
  }

  static List<AlarmDataModel> listFromJson(List<dynamic> list) {
    List<AlarmDataModel> rows = list.map((i) => AlarmDataModel.fromJson(i)).toList();
    return rows;
  }

  static List<AlarmDataModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<AlarmDataModel>((json) => AlarmDataModel.fromJson(json)).toList();
  }

  Map<String,dynamic> toJson()=>{
    'alarmid' : alarmid,
    'hour':hour,
    'minute':minute,
    'mon' : mon,
    'tues' : tues,
    'wed' : wed,
    'thur' : thur,
    'fri' : fri,
    'sat' : sat,
    'sun' : sun,
    'ringtone' : ringtone,
    'repeat' : repeat,
  };


  Map<String, dynamic> toMap() {
    return {
      'alarmid' : alarmid,
      'hour' : hour,
      'minute':minute,
      'mon' : mon,
      'tues' : tues,
      'wed' : wed,
      'thur' : thur,
      'fri' : fri,
      'sat' : sat,
      'sun' : sun,
      'ringtone' : ringtone,
      'repeat' : repeat,
    };
  }

  factory AlarmDataModel.fromMap(Map<String, dynamic> map) {
    return AlarmDataModel(

      alarmid : map['alarmid'],
      hour : map['hour'],
      minute : map['minute'],
      mon : map['mon'],
      tues : map['tues'],
      wed : map['wed'],
      thur : map['thur'],
      fri : map['fri'],
      sat : map['sat'],
      sun : map['sun'],
      ringtone : map['ringtone'],
      repeat : map['repeat'],
    );
  }








}