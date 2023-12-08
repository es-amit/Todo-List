import 'package:flutter/material.dart';
import 'package:to_do_list/database/database.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/screen/new_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<Todo>> allTasks;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async{
    allTasks = dbHelper!.getDataList();
  }

  deleteTask(String key) async{
    dbHelper!.delete(key);
  }


  statusTask(Todo currentTodo,bool updateStatus,String id) async{
    dbHelper!.updateStatus(Todo(
      title: currentTodo.title, 
      description: currentTodo.description, 
      taskPriority: currentTodo.taskPriority, 
      category: currentTodo.category, 
      status: updateStatus
      )
      ,id     
    );
    loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo list"),
      ),
      body:SafeArea(
        child: FutureBuilder(
          future: allTasks, 
          builder: (context,AsyncSnapshot<List<Todo>> snapshot){
            if(!snapshot.hasData || snapshot.data == null){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.data!.isEmpty){
              return const Center(
                child: Text("No tasks available"),
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  return Dismissible(
                    key: ValueKey(snapshot.data![index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction){
                      deleteTask(snapshot.data![index].id);
                    },
                    child: Card(
                      color: priorityColor[snapshot.data![index].taskPriority],
                      elevation: 10, 
                      clipBehavior: Clip.hardEdge,
                      child: ListTile(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewTask(editTask: true)));
                        },
                        leading: Icon(categoryIcons[snapshot.data![index].category],
                          size: 32,),
                        title: Text(snapshot.data![index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data![index].description),
                            Row(
                              children: [
                                Text("Category: ${snapshot.data![index].category.name}"),
                                Text(" | Date: ${snapshot.data![index].taskPriority.name}"),             
                              ],
                            )
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Checkbox(
                          value: snapshot.data![index].status, 
                          onChanged: (newvalue){
                            setState(() {
                              statusTask(snapshot.data![index], newvalue!,snapshot.data![index].id);
                            });
                          }
                        ),
                      ),
                    ),
                  );
                }
                )
              );
        
            }
          }),
      )
      ,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>NewTask(editTask: false,)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width * (1/2),
            height: 50,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 4
                )
              ],
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 239, 146, 146),
                  Color.fromARGB(255, 251, 69, 69),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
            
            child: Align(
              alignment: Alignment.center,
              child: Text("Add New Task",
                style: Theme.of(context).textTheme.titleSmall,),
            ),
          ),
        ),
      ),
    );
  }

}