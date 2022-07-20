import 'dart:convert';

class DataModel{
  int? dataId;
  int month;
  int day;
  int year;
  int answer;
  String content;



  DataModel({
    this.dataId,
    required this.month,
    required this.year,
    required this.day,
    required this.content,
    required this.answer,

  });


  factory DataModel.fromJson(Map<String,dynamic> parsedJson){
    return DataModel(
      dataId : parsedJson['dataId'],
      month : parsedJson['month'],
      year : parsedJson['year'],
      day : parsedJson['day'],
      answer : parsedJson['answer'],
      content : parsedJson['content'],

    );
  }

  static List<DataModel> listFromJson(List<dynamic> list) {
    List<DataModel> rows = list.map((i) => DataModel.fromJson(i)).toList();
    return rows;
  }

  static List<DataModel> listFromString(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<DataModel>((json) => DataModel.fromJson(json)).toList();
  }

  Map<String,dynamic> toJson()=>{
    'dataId' : dataId,
    'month':month,
    'year':year,
    'day' : day,
    'content' : content,
    'answer' : answer,

  };


  Map<String, dynamic> toMap() {
    return {
      'dataId' : dataId,
      'month' : month,
      'year':year,
      'day' : day,
      'content' : content,
      'answer' : answer,

    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(

      dataId : map['dataId'],
      month : map['month'],
      year : map['year'],
      day : map['day'],
      content : map['content'],
      answer : map['answer'],

    );
  }








}