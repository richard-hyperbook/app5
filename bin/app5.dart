// import 'package:app5/app5.dart' as app5;
 
import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();

Future main(final context) async { 
  client
    .setEndpoint("https://fra.cloud.appwrite.io/v1")
    .setProject("app5")
    .setKey("standard_bb51a77f5ef2a053be10ecf85be6c97fe0014dcd6050b1743641434170316f2afbabf69052d7beb0adfa09b12d44b317673658b3baa105cfd6b35bbce8c0a2fff4df0c56f3922b85ff39b09ade414b73c20fe2eb329a6b306a0dfceba91ad0e75f0fc7de0f7fdd559282b7ea0a2fb3021e687d873b9d0cde911da9f759ebc490");

    await prepareDatabase();
    await Future.delayed(const Duration(seconds: 1));
    await seedDatabase();
    await getTodos();

}
var databases;
var todoDatabase;
var todoTable;
var tablesDB;

Future<void> prepareDatabase() async {
  tablesDB = TablesDB(client);

  todoDatabase = await tablesDB.create(
    databaseId: ID.unique(), 
    name: 'TodosDB'
  );

  todoTable = await tablesDB.createTable(
    databaseId: todoDatabase.$id, 
    tableId: ID.unique(), 
    name: 'Todos'
  );

  await tablesDB.createStringColumn(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    key: 'title',
    size: 255,
    xrequired: true
  );

  await tablesDB.createStringColumn(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    key: 'description',
    size: 255,
    xrequired: false,
    xdefault: 'This is a test description'
  );

  await tablesDB.createBooleanColumn(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    key: 'isComplete',
    xrequired: true
  );
}

Future<void> seedDatabase() async {
  var testTodo1 = {
    'title': 'Buy apples',
    'description': 'At least 2KGs',
    'isComplete': true
  };

  var testTodo2 = {
    'title': 'Wash the apples',
    'isComplete': true
  };

  var testTodo3 = {
    'title': 'Cut the apples',
    'description': 'Don\'t forget to pack them in a box',
    'isComplete': false
  };

  await tablesDB.createRow(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    rowId: ID.unique(),
    data: testTodo1
  );

  await tablesDB.createRow(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    rowId: ID.unique(),
    data: testTodo2
  );

  await tablesDB.createRow(
    databaseId: todoDatabase.$id,
    tableId: todoTable.$id,
    rowId: ID.unique(),
    data: testTodo3
  );
}

Future<void> getTodos() async {
  var todos = await tablesDB.listRows(
    databaseId: todoDatabase.$id, 
    tableId: todoTable.$id
  );

  todos.rows.forEach((todo) {
    print('Title: ${todo.data['title']}\nDescription: ${todo.data['description']}\nIs Todo Complete: ${todo.data['isComplete']}\n\n');
  });
}
