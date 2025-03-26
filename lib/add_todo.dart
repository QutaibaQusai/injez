import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleControler = TextEditingController();
  TextEditingController describtionControler = TextEditingController();
  bool isCompleted = true;

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
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note", style: TextStyle(fontWeight: FontWeight.w500)),
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
                onPressed: createNote,
                child: Text("Add Note", style: TextStyle(color: Colors.white)),
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
