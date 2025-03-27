import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key, this.todo});
  final Map? todo;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController describtionControler = TextEditingController();
  bool isCompleted = true;
  bool isEdit = false;

  // create todo
  Future<void> createNote() async {
    final uri = 'https://api.nstack.in/v1/todos';
    final url = Uri.parse(uri);
    final body = {
      "title": titleControler.text,
      "description": describtionControler.text,
      "is_completed": isCompleted,
    };
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("The Note has been successfully created.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  // update todo
  Future<void> upddateTodo({required String id}) async {
    final uri = "https://api.nstack.in/v1/todos/$id";
    final url = Uri.parse(uri);
    final body = {
      "title": titleControler.text,
      "description": describtionControler.text,
      "is_completed": isCompleted,
    };
    final response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("The Note has been successfully Updated.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      titleControler.text = todo['title'];
      describtionControler.text = todo['description'];
      isCompleted = todo['is_completed'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Note" : "Add Note",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleControler,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
                SizedBox(width: 40),
                Switch(
                  value: isCompleted,
                  onChanged: (v) {
                    setState(() {
                      isCompleted = !isCompleted;
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: describtionControler,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Description'),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  isEdit ? upddateTodo(id: widget.todo!['_id']) : createNote();
                },
                child: Text(
                  isEdit ? "Update Note" : "Add Note",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
