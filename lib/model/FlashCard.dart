class FlashCard{

  int id;
  String front;
  String back;
  int deck;

  FlashCard(this.deck, this.front, this.back);

  FlashCard.fromMap(Map map){

    this.id = map["id"];
    this.front = map["front"];
    this.back = map["back"];
    this.deck = map["id_deck"];
    //this.subject.name = map["subject.name"]; obs agora não mais, desisti de usar o objeto
    //Aqui possivelmente devese pegar os demais atributos do subjet

  }

  Map toMap(){

    Map<String, dynamic> map = {
      'front' : this.front,
      'back' : this.back,
      'id_deck' : this.deck,
    };

    if(this.id != null){
      map['id'] = this.id;
    }

    return map;

  }

}
