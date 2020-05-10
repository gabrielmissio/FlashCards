import 'dart:io';
import 'package:flashcards/model/Deck.dart';
import 'package:flashcards/model/FlashCard.dart';
import 'package:flashcards/model/Subject.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "FlashCardDB.db";
  static final _databaseVersion = 1;
  static final table = 'subject';
  static final columnId = '_id';
  static final columnNome = 'nome';
  static final columnIdade = 'idade';
  static final table2 = 'deck';
  static final table3 = 'flashcard';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  // tem somente uma referência ao banco de dados
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
  Future CreateTable1(Database db)async{
    await db.execute('''
         
          CREATE TABLE subject (
            id INTEGER PRIMARY KEY autoincrement, 
            name VARCHAR
          )
        
          ''');
  }
  Future CreateTable2(Database db)async{
    await db.execute('''
          
          CREATE TABLE deck (
          id INTEGER PRIMARY KEY autoincrement, 
          name VARCHAR, 
          id_subject INTEGER, 
          FOREIGN KEY(id_subject) REFERENCES subject(id)
          )  
        
          ''');
  }
  Future CreateTable3(Database db)async{
    await db.execute('''
          
          CREATE TABLE $table3 (
          id INTEGER PRIMARY KEY autoincrement, 
          front TEXT,
          back TEXT, 
          id_deck INTEGER, 
          FOREIGN KEY(id_deck) REFERENCES deck(id)
          )  
        
          ''');
  }
  /*
    this.id = map["id"];
    this.front = map["front"];
    this.back = map["back"];
    this.deck = map["id_deck"];
  * */

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database db, int version) async {
    CreateTable1(db);
    CreateTable2(db);
    CreateTable3(db);
  }



  //CRUD DECKS
  Future<int> insertDeck(Deck deck) async {
    Database db = await instance.database;
    return await db.insert(table2, deck.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllDecks() async {
    Database db = await instance.database;
    return await db.query(table2);
  }

  Future<List<Map<String, dynamic>>> queryDecksSubjects(String idSubject)async{
    Database bd = await instance.database;
    return await bd.rawQuery(' SELECT * FROM $table2 WHERE id_subject = $idSubject');
        //'WHERE id_subject = $idSubject ');
  }

  Future<int> deleteDeck(int id) async {
    Database db = await instance.database;
    return await db.delete(table2, where: 'id = ?', whereArgs: [id]);
  }

  //    Database bd = await _recuperarBancoDados();
//
//    String sql = "SELECT * FROM subject ";
//    List usuarios = await bd.rawQuery(sql);

  //CRUD SUBJECTS

  Future<int> insert(Subject subject) async {
    Database db = await instance.database;
    return await db.insert(table, subject.toMap());
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteSubject(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }


  //CRUD FLASH CARDS

  Future<int> insertFlashCard(FlashCard flashCard) async {
    Database db = await instance.database;
    return await db.insert(table3, flashCard.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllFlashCard() async {
    Database db = await instance.database;
    return await db.query(table3);
  }

  Future<List<Map<String, dynamic>>> queryFlashCardDeck(String idDeck)async{
    Database bd = await instance.database;
    return await bd.rawQuery(' SELECT * FROM $table3 WHERE id_deck = $idDeck');
    //'WHERE id_subject = $idSubject ');
  }

  Future<int> deleteFlashCard(int id) async {
    Database db = await instance.database;
    return await db.delete(table3, where: 'id = ?', whereArgs: [id]);
  }

  /*
    this.id = map["id"];
    this.front = map["front"];
    this.back = map["back"];
    this.deck = map["id_deck"];
  * */

  // Todos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }


  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }
  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
