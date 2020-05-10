import 'package:flashcards/helper/DatabaseHelper.dart';
import 'package:flashcards/model/Subject.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'DeckScreen.dart';

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {

  TextEditingController textNewSubcjetName = new TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  List<Subject> _listSubjects = new List<Subject>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarSubjets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBJECTS'),
        actions: <Widget>[
          RaisedButton(
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            color: Colors.blue,
            elevation: 0,
            onPressed: () {
              _newSubject();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
//        width: double.infinity,
//        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: ListView.builder(
                    itemCount: _listSubjects.length,
                    itemBuilder: (context, index) {
                      final dex = _listSubjects[index];
                        return Dismissible(
                          onDismissed: ( direction ){
                            String name = _listSubjects[index].name;
                            Subject deletedeSubject = _listSubjects[index];
                            _deleteSubject(_listSubjects[index].id);
                            Scaffold
                                .of(context)
                                .showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 10),
                                action: SnackBarAction(label: 'CANCEL', onPressed: (){
                                  _recupera(deletedeSubject);
                                }),
                                content:
                                Text(
                                    "The subject $name was deleted"),
                              ),
                            );

                        },
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            padding: EdgeInsets.all(16),
                            //edit
                            //color: Colors.amber,
                            child: Row(
                              children: <Widget>[
                                //Text(_listSubjects[index].name),
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                          key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                          child: Card(
                          color: Colors.blue,
                            child: ListTile(
                              title: Text(
                                //'A',
                                dex.name,// + index.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              onTap: () {
                                var route = MaterialPageRoute(
                                  builder: (BuildContext context) => new DeckScreen(value: dex.id.toString()),
                                );
                                Navigator.of(context).push(route);
                              },
    //                          onLongPress: () {
    //                            Toast.show('Long Click' + index.toString(), context,
    //                                duration: Toast.LENGTH_SHORT,
    //                                gravity: Toast.BOTTOM);
    //                          },
                              ),
                          ),
                        );
//                      return Card(
//                        color: Colors.blue,
//                        child: ListTile(
//                          title: Text(
//                            //'A',
//                            dex.name,// + index.toString(),
//                            style: TextStyle(color: Colors.white, fontSize: 18),
//                          ),
//                          onTap: () {
//                            var route = MaterialPageRoute(
//                              builder: (BuildContext context) => new DeckScreen(value: dex.id.toString()),
//                            );
//                            Navigator.of(context).push(route);
//                          },
////                          onLongPress: () {
////                            Toast.show('Long Click' + index.toString(), context,
////                                duration: Toast.LENGTH_SHORT,
////                                gravity: Toast.BOTTOM);
////                          },
//                        ),
//                      );
                    })),
          ],
        ),
      ),
    );
  }

  Future<void> _newSubject() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'NEW SUBJECT',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'NAME',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue
                        )
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,

                  ),
                  controller: textNewSubcjetName,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                textNewSubcjetName.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                _inserir2();
                textNewSubcjetName.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _recupera(Subject subject) async {

    final id = await dbHelper.insert(subject);
    print('linha inserida id: $id');
    _recuperarSubjets();

  }

  _deleteSubject(int id){

    dbHelper.deleteSubject(id);
    _recuperarSubjets();

  }

  _recuperarSubjets()async{

    List subjectsRecuperados = await dbHelper.queryAllRows();

    List<Subject> listaTemporaria = List<Subject>();
    for( var item in subjectsRecuperados){

      Subject subject = Subject.fromMap(item);
      listaTemporaria.add(subject);

    }

    setState(() {
      _listSubjects = null;
      _listSubjects = listaTemporaria;
    });
    listaTemporaria = null;

  }

  void _consultar() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }

  void _inserir2() async {
    // linha para incluir
    String name = 'default';
    if(textNewSubcjetName.text != '' && textNewSubcjetName.text != ' '){
      name = textNewSubcjetName.text;
    }
    name = name.toUpperCase();
    Subject subject = new Subject(name);
    final id = await dbHelper.insert(subject);
    print('linha inserida id: $id');
    _recuperarSubjets();
  }

}

/*
* import 'package:flashcards/helper/DatabaseHelper.dart';
import 'package:flashcards/model/Subject.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'DeckScreen.dart';

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {

  TextEditingController textNewSubcjetName = new TextEditingController();
  final dbHelper = DatabaseHelper.instance;
  List<Subject> _listSubjects = new List<Subject>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarSubjets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUBJECTS'),
        actions: <Widget>[
          RaisedButton(
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            color: Colors.blue,
            elevation: 0,
            onPressed: () {
              _newSubject();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
//        width: double.infinity,
//        height: double.infinity,
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: ListView.builder(
                    itemCount: _listSubjects.length,
                    itemBuilder: (context, index) {
                      final dex = _listSubjects[index];

                      return Card(
                        color: Colors.blue,
                        child: ListTile(
                          title: Text(
                            //'A',
                            dex.name,// + index.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onTap: () {
                            var route = MaterialPageRoute(
                              builder: (BuildContext context) => new DeckScreen(value: dex.id.toString()),
                            );
                            Navigator.of(context).push(route);
                          },
//                          onLongPress: () {
//                            Toast.show('Long Click' + index.toString(), context,
//                                duration: Toast.LENGTH_SHORT,
//                                gravity: Toast.BOTTOM);
//                          },
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }

  Future<void> _newSubject() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'NEW SUBJECT',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'NAME',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue
                        )
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,

                  ),
                  controller: textNewSubcjetName,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                textNewSubcjetName.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                _inserir2();
                textNewSubcjetName.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _recuperarSubjets()async{

    List subjectsRecuperados = await dbHelper.queryAllRows();

    List<Subject> listaTemporaria = List<Subject>();
    for( var item in subjectsRecuperados){

      Subject subject = Subject.fromMap(item);
      listaTemporaria.add(subject);

    }

    setState(() {
      _listSubjects = listaTemporaria;
    });
    listaTemporaria = null;

  }

  void _consultar() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }

  void _inserir2() async {
    // linha para incluir
    String name = 'default';
    if(textNewSubcjetName.text != '' && textNewSubcjetName.text != ' '){
      name = textNewSubcjetName.text;
    }
    name = name.toUpperCase();
    Subject subject = new Subject(name);
    final id = await dbHelper.insert(subject);
    print('linha inserida id: $id');
    _recuperarSubjets();
  }

}
*/
