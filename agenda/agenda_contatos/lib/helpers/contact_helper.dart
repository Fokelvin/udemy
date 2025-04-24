import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



final String contactTable = "contactTable";
final String idColumn = "idColum";
final String nameColunm = "nameColunm";
final String emailColunm = "emailColunm"; 
final String phoneColunm = "phoneColunm";
final String imgColunm = "imgColunm";

class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database? _db;

  Future <Database> get db async{
    if (_db !=null){
      return _db!;
    }else{
      _db = await initdb();
      return _db!;
    }
  }

  Future <Database> initdb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColunm TEXT, $emailColunm TEXT, $phoneColunm TEXT, $imgColunm TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable, 
    columns: [idColumn, nameColunm, emailColunm, phoneColunm, imgColunm], 
    where: "$idColumn = ?",
    whereArgs: [id]);
    if (maps.isNotEmpty){
      return Contact.fromMap(maps.first);
    }else {
      throw Exception("Contact with id $id not found");
    }
  }

  Future <int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future <int> updateContact(Contact contact) async{
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async{
    Database dbContact = await db;
    List listmap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List<Contact>.empty(growable: true);
    for (Map item in listmap){
      listContact.add(Contact.fromMap(item));
    }
    return listContact;
  }

  Future<int?> getNumber() async{
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }

}

class Contact{

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact();

  Contact.fromMap(Map map){
    
    id = map[idColumn];
    name = map[nameColunm];
    email = map[emailColunm];
    phone = map[phoneColunm];
    img = map[imgColunm];

  }

  Map<String, Object?> toMap(){
    Map<String, Object?> map = {
      nameColunm: name,
      emailColunm: email,
      phoneColunm: phone,
      imgColunm: img,
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}