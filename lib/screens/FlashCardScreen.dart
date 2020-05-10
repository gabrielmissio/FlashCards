import 'package:flashcards/helper/DatabaseHelper.dart';
import 'package:flashcards/model/FlashCard.dart';
import 'package:flutter/material.dart';

class FlashCardScreen extends StatefulWidget {

  final String value;

  FlashCardScreen({Key key, this.value}) : super (key: key);

  @override
  _FlashCardScreenState createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {

  final dbHelper = DatabaseHelper.instance;
  List<FlashCard> _listFlashCards = List<FlashCard>();
  TextEditingController textNewFrontFlash = new TextEditingController();
  TextEditingController textNewBackFlash = new TextEditingController();


  int cont = 0;
  int listSize = 0;
  bool status = true;
  String textCard;
  int axtCont = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarSubjets();
    //_recupere();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FLASH CARDS'),
        centerTitle: true,
        actions: <Widget>[
          SizedBox(
            width: 55,
            child: RaisedButton(
                child: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
                color: Colors.blue,
                elevation: 0,
                onPressed: (){

                  if(listSize > 0){
                    _deleteFlashCard();
                  }else{
                    _noFlashCard();
                  }

                }),
          ),
          SizedBox(
              width: 55,
              child: RaisedButton(
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                  ),
                  color: Colors.blue,
                  elevation: 0,
                  onPressed: (){

                    _newFlashCard();
                    //new flash card daiolog

                  },)
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        //color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                //s color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 500,
                        child: RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            child: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.blue,
                              textDirection: TextDirection.rtl,
                              size: 60,
                            ),
                            onPressed: (){
                              if(cont > 0){
                                cont--;
                                status = true;
                              }
                              setState(() {
                                textCard = _listFlashCards[cont].front;
                                axtCont = cont + 1;
                              });
                            }

                        ),
                      ),
                    ],)
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                //     color: Colors.deepPurple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: SizedBox()),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '$axtCont/$listSize',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.white,
                                elevation: 0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      '$textCard',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(),
                                  ],
                                ),
                                onPressed: (){
                                  if(status){
                                    status = false;
                                  }else{
                                    status = true;
                                  }
                                  listSize = _listFlashCards.length;
                                  setState(() {
                                    if(status){
                                      textCard = _listFlashCards[cont].front;
                                    }else{
                                      textCard = _listFlashCards[cont].back;
                                    }
                                  });
                                })
                        ),
                      ),
                    ],)
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
//                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 500,
                        child: RaisedButton(
                            color: Colors.white,
                            elevation: 0,

                            child: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.blue,
                              size: 60,
                              textDirection: TextDirection.ltr,
                            ),
                            onPressed: (){
                              if(cont < _listFlashCards.length-1){
                                cont++;
                                status = true;
                              }
                              setState(() {
                                textCard = _listFlashCards[cont].front;
                                axtCont = cont + 1;
                              });
                            }
                        ),
                      ),
                    ],)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _newFlashCard() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'NEW FLASH CARD',
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
                    labelText: 'FRONT',
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
                  controller: textNewFrontFlash,
                ),
                SizedBox(
                  width: 10,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'BACK',
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
                  controller: textNewBackFlash,
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                //textNewDeckName.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SAVE'),
              onPressed: () {
                _inserir2();
                Navigator.of(context).pop();
                textNewBackFlash.clear();
                textNewFrontFlash.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFlashCard() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'DELETE FLASH CARD',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),

          content: SingleChildScrollView(
            child: Text('DO YOU RELLY WANT TO DELETE THIS CARD? ', style: TextStyle(color: Colors.blue),),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                //textNewDeckName.clear();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('DELETE'),
              onPressed: () {
                deleteFlashCard(_listFlashCards[cont].id);
                Navigator.of(context).pop();
                //textNewDeckName.clear();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _noFlashCard() async {
    return showDialog<void>(
      context: this.context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'THERE IS NO FLASH CARDS',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),

          content: SingleChildScrollView(
            child: Text('THE DECK IS EMPTY!', style: TextStyle(color: Colors.blue),),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                // _inserir2();
                Navigator.of(context).pop();
                //textNewDeckName.clear();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteFlashCard(int id) async{

    dbHelper.deleteFlashCard(id);
    _recuperarSubjets();

  }

  void _inserir2() async {
    // linha para incluir
    String front = 'front default';
    String back = 'back default';

    if(textNewFrontFlash.text != '' && textNewFrontFlash.text != ' '){
      front = textNewFrontFlash.text;
    }
    if(textNewBackFlash.text != '' && textNewBackFlash.text != ' '){
      back = textNewBackFlash.text;
    }

    front = front.toUpperCase();
    back = back.toUpperCase();
    //Deck deck = new Deck(int.parse(widget.value), name);
    FlashCard flashCard = new FlashCard(int.parse(widget.value), front, back);
    final id = await dbHelper.insertFlashCard(flashCard);
    print('linha inserida id: $id');
    _recuperarSubjets();

  }

  _recuperarSubjets()async{

   // _consultar();
    List flashCardsRecuperados = await dbHelper.queryFlashCardDeck(widget.value);

    List<FlashCard> listaTemporaria = List<FlashCard>();
    for( var item in flashCardsRecuperados){

      FlashCard flashCard = FlashCard.fromMap(item);
      listaTemporaria.add(flashCard);

    }

    setState(() {
      _listFlashCards = listaTemporaria;
    });

    listaTemporaria = null;


    setState(() {


      if(axtCont == listSize && axtCont > 1){
        print('ihual');
        cont--;
      }

      if(_listFlashCards.length == 0){
        textCard = 'THE DECK IS EMPTY...';
        listSize = _listFlashCards.length;
        axtCont = cont;
      }else{
        if(cont >= 0 && cont <= _listFlashCards.length){
          textCard = _listFlashCards[cont].front;
          listSize = _listFlashCards.length;
          axtCont = cont + 1;
        }
      }
    });

  }

}
