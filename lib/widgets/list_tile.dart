import 'package:flutter/material.dart';
import 'package:to_do_list/model/todo.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key,required this.snapshot});

  final Todo snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      elevation: 6,

      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.orange,
          minRadius: 20,
        ),
        
        title: Text(snapshot.title),
        subtitle: Text(snapshot.description),
        trailing: Text(snapshot.category.name),
      ),
    );
  }
}