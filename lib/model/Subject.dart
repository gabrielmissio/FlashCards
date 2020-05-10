class Subject{

  int id;
  String name;

  Subject(this.name);

  Map toMap(){

    Map<String, dynamic> map = {
      'name' : this.name,
    };

    if(this.id != null){
      map['id'] = this.id;
    }

    return map;

  }

  Subject.fromMap(Map map){

    this.id = map["id"];
    this.name = map["name"];

  }

}