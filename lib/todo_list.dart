import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injez/add_todo.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  bool isLoading = false;

  // get todo
  Future<void> getNotes() async {
    setState(() {
      isLoading = true;
    });

    final uri = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final url = Uri.parse(uri);
    final response = await http.get(
      url,
      headers: {'accept': 'application/json'},
    );
    final json = jsonDecode(response.body) as Map;
    final result = json['items'] as List;

    setState(() {
      items = result;
      isLoading = false;
    });
  }

  // delete note
  Future<void> deleteNote({required String id}) async {
    final uri = "https://api.nstack.in/v1/todos/$id";
    final url = Uri.parse(uri);
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      setState(() {
        getNotes();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => getNotes(),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text(item['title']),
                      trailing: PopupMenuButton(
                        onSelected: (v) {
                          if (v == 'Edit') {
                          } else if (v == 'Delete') {
                            deleteNote(id: item['_id']);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(child: Text("Edit"), value: 'Edit'),
                            PopupMenuItem(
                              child: Text("Delete"),
                              value: 'Delete',
                            ),
                          ];
                        },
                      ),
                    );
                  },
                ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
