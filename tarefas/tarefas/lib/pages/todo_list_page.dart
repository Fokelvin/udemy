import 'package:flutter/material.dart';
import 'package:tarefas/models/todo.dart';
import 'package:tarefas/repositories/todo_repository.dart';
import 'package:tarefas/widgets/TodoListItem.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  Todo? deleteTodo;
  int? deleteTodoPos;
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        labelStyle: TextStyle(
                          color: Colors.teal),
                        hintText: 'Ex.: Estudar Flutter',
                        errorText: errorText,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      String text = todoController.text;
                      if (text.isEmpty) {
                        setState(() {
                          errorText = "Campo não pode ser vazio";
                        });
                        return;
                      }
                      setState(() {
                        Todo newTodo = Todo(
                          title: text,
                          dateTime: DateTime.now(),
                        );
                        todos.add(newTodo);
                        errorText = null;
                      });
                      todoController.clear();
                      todoRepository.saveTodoList(todos);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.all(15),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 33,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child:
                        Text("Voce possui ${todos.length} tarefas pendentes"),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: showDeleteConfirmation,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.all(8),
                    ),
                    child: Text(
                      "Limpar tudo",
                      style: TextStyle(color: Colors.white.withOpacity(1.0)),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void onDelete(Todo todo) {
    deleteTodo = todo;
    deleteTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title}Foi removida com sucesso',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.teal,
          onPressed: () {
            setState(() {
              todos.insert(deleteTodoPos!, deleteTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Deseja realmente deletar todos os registros?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Limpar tudo'),
          ),
        ],
      ),
    );
  }

  deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
