import 'package:flashcards/helper/DatabaseHelper.dart';
import 'package:flashcards/model/Deck.dart';
import 'package:flashcards/model/Subject.dart';
import 'package:flashcards/screens/FlashCardScreen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class DeckScreen extends StatefulWidget {

  final String value;

  DeckScreen({Key key, this.value}) : super (key: key);
  
  @override
  _DeckScreenState createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {

  List<Deck> _listDecks = new List<Deck>();
  final dbHelper = DatabaseHelper.instance;
  TextEditingController textNewDeckName = new TextEditingController();

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
        title: Text('DECKS'),
        actions: <Widget>[
          RaisedButton(
            child: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            color: Colors.blue,
            elevation: 0,
            onPressed: () {
              _newDeck();
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
                    itemCount: _listDecks.length,
                    itemBuilder: (context, index) {
                      final dex = _listDecks[index];

                      return Dismissible(
                        onDismissed: ( direction ){
                          String name = _listDecks[index].name;
                          Deck deletedeDeck = _listDecks[index];
                          _deleteDeck(_listDecks[index].id);
                          Scaffold
                              .of(context)
                              .showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 10),
                              action: SnackBarAction(label: 'CANCEL', onPressed: (){
                                //Toast.show(deletedeDeck.subject.toString(), context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                _recupera(deletedeDeck);
                              }),
                              content:
                              Text(
                                  "The deck $name was deleted"),
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
                                builder: (BuildContext context) => new FlashCardScreen(value: dex.id.toString()),
                              );
                              Navigator.of(context).push(route);
                            },
                          ),
                        ),
                      );
//                      Card(
//                        color: Colors.blue,
//                        child: ListTile(
//                          title: Text(
//                            //'A',
//                            dex.name,// + index.toString(),
//                            style: TextStyle(color: Colors.white, fontSize: 18),
//                          ),
//                          onTap: () {
//                            var route = MaterialPageRoute(
//                              builder: (BuildContext context) => new FlashCardScreen(value: dex.id.toString()),
//                            );
//                            Navigator.of(context).push(route);
//                          },
//                        ),
//                      );
                    })),
          ],
        ),
      ),
    );
  }

  Future<void> _newDeck() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'NEW DECK',
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
                  controller: textNewDeckName,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                textNewDeckName.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                _inserir2();
                Navigator.of(context).pop();
                textNewDeckName.clear();
              },
            ),
          ],
        );
      },
    );
  }

  _recuperarSubjets()async{

    _consultar();
    List decksRecuperados = await dbHelper.queryDecksSubjects(widget.value);

    List<Deck> listaTemporaria = List<Deck>();
    for( var item in decksRecuperados){

      Deck deck = Deck.fromMap(item);
      listaTemporaria.add(deck);

    }

    setState(() {
      _listDecks = listaTemporaria;
    });
    listaTemporaria = null;

  }

  _deleteDeck(int id){

    dbHelper.deleteDeck(id);
    _recuperarSubjets();

  }

  void _consultar() async {
    final todasLinhas = await dbHelper.queryDecksSubjects(widget.value);
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }


  void _inserir2() async {
    // linha para incluir
    String name = 'default';
    if(textNewDeckName.text != '' && textNewDeckName.text != ' '){
      name = textNewDeckName.text;
    }
    name = name.toUpperCase();
    Deck deck = new Deck(int.parse(widget.value), name);
    final id = await dbHelper.insertDeck(deck);
    print('linha inserida id: $id');
    _recuperarSubjets();

    }

  void _recupera(Deck deck) async {

    final id = await dbHelper.insertDeck(deck);
    print('linha inserida id: $id');
    _recuperarSubjets();

  }

}
