
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Priority{
  high,
  medium,
  low
}

final formatter = DateFormat.yMd();


enum Category{
  work,
  food,
  leisure,
  travel
}

const categoryIcons = {
  Category.food : Icons.lunch_dining,
  Category.travel : Icons.flight_takeoff,
  Category.leisure : Icons.movie,
  Category.work : Icons.work
};

 const priorityColor = {
  Priority.high : Color.fromARGB(255, 241, 164, 164),
  Priority.medium : Color.fromARGB(255, 255, 255, 164),
  Priority.low : Color.fromARGB(255, 140, 237, 190),
  
  
};


class Todo{
  late final int? id;
  late String title;
  late String description;
  //DateTime date = DateTime.now();
  late Priority taskPriority;
  late bool status;
  late Category category;

  Todo(
    { 
      this.id,
      required this.title,
      required this.description,
      // required this.date,
      required this.taskPriority,
      required this.category,
      required this.status,
    
  });

  Map<String,dynamic> toMap(){
    // DateFormat formatDate = DateFormat('yyyy-MM-dd');
    // String dateString =date.toIso8601String();
    // print(dateString);
    return {
      'id' : id,
      'title' : title,
      'description' : description,
      'priority' : taskPriority.toString().split('.').last,
      'category' : category.toString().split('.').last,
      // 'date' : dateString,
      'status' : status ? 1 : 0,
    };
  }

  Todo.fromMap(Map<String,dynamic> map){
    // String dateString = map['date'];
    // DateFormat format = DateFormat("yyyy-MM-dd");
    // DateTime dateTime = format.parse(dateString);
    id = map['id'];
    title = map['title'];
    description = map['description'];
    status = map['status'] == 1;
    taskPriority = Priority.values.firstWhere((element) => element.toString() == 'Priority.${map['priority']}');
    category = Category.values.firstWhere((element) => element.toString() == 'Category.${map['category']}');
    // date = dateTime;
  }
  
}