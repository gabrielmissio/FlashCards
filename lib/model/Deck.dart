import 'package:flashcards/model/Subject.dart';

class Deck{


  int id;
  int subject;
  String name;

  Deck(this.subject, this.name);

  Deck.fromMap(Map map){

    this.id = map["id"];
    this.name = map["name"];
    this.subject = map["id_subject"];
    //this.subject.name = map["subject.name"];
    //Aqui possivelmente devese pegar os demais atributos do subjet

  }

  Map toMap(){

    Map<String, dynamic> map = {
      'name' : this.name,
      'id_subject' : this.subject,
    };

    if(this.id != null){
      map['id'] = this.id;
    }

    return map;

  }

}