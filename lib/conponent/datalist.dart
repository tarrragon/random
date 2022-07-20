import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random/models/dataModel.dart';
import 'package:random/providers/data_provider.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);



  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  @override
  Widget build(BuildContext context) {
    return
          Expanded(
          child: StreamBuilder<List<DataModel>>(

          stream: context.watch<DataProvider>().getDataStream,
      builder: (BuildContext context, AsyncSnapshot<List<DataModel>> snapshot) {

          if (snapshot.hasData ||snapshot.hasError ||snapshot.data == null) {
            if (snapshot.data == null|| snapshot.hasError) {
              return const Text('No Data');
            }
            return ListView.builder(
            itemCount: snapshot.data!.isEmpty ? 0 : snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(25),
                child: TextButton(
                  child:  Text(
                    snapshot.data![index].content,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    editDialog(snapshot.data![index]);
                  },
                ),
              );

            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
      },
    ),
        );
  }
  editDialog(DataModel data) {
    TextEditingController _edit = TextEditingController();
    _edit.text = data.content;
    var dialog = CupertinoAlertDialog(
      content: TextField(
        controller: _edit,

        style: const TextStyle(fontSize: 20),
      ),
      actions: <Widget>[

        CupertinoButton(
          child: const Text("確認"),
          onPressed: () {
            context
                .read<DataProvider>()
                .update.add(DataModel(month: data.month, year: data.year, day: data.day, content: _edit.text, answer: data.answer));

            Navigator.pop(context);


          },

        ),
        CupertinoButton(
          child: const Text("返回"),
          onPressed: () {

            Navigator.pop(context);


          },

        ),
        CupertinoButton(
          child: const Text("刪除"),
          onPressed: () {
            context.read<DataProvider>().delete.add(data.dataId!);
            Navigator.pop(context);


          },

        ),



      ],
    );


  }
}
