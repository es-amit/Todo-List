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

  void showSnackbar(String msg){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 2000),
        
      )
    );
  }
  deleteTask(int key,int index) async{
    await dbHelper!.delete(key);
    showSnackbar("Item Deleted!!");
    setState(() {
      allTasks = dbHelper!.getDataList();
    });
  }


  statusTask(Todo currentTodo,bool updateStatus,int id) async{
    dbHelper!.updateStatus(Todo(
      id: currentTodo.id,
      title: currentTodo.title, 
      description: currentTodo.description, 
      taskPriority: currentTodo.taskPriority, 
      category: currentTodo.category, 
      // date: currentTodo.date,
      status: updateStatus
      )
      ,id     
    );
    showSnackbar(updateStatus ? "Task Completed!!" : "Task Uncomplete!!");
    loadData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo list",
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic
          ),),
      ),
      body:SafeArea(
        child: FutureBuilder(
          future: allTasks, 
          builder: (context,AsyncSnapshot<List<Todo>> snapshot){
            if(!snapshot.hasData || snapshot.data == null){
              print(snapshot.error);
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.data!.isEmpty){
              return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No Tasks Available",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38
                      ),
                    ),
                    
                    IconButton(onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>NewTask(editTask: false,)));
                    },
                    icon: const Icon(Icons.add_circle_rounded,
                      color: Colors.black38,
                      size: 80
                      )
                    ),
                    const Text("Click here to Add Tasks",
                      style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38
                  ),
                  ),
                  ],
                )
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
                      deleteTask(snapshot.data![index].id!,index);
                    },
                    background: Container(
                      margin:const  EdgeInsets.only(bottom: 10),
                      color: Colors.redAccent,
                    ),
                    child: Container(   
                      padding:const EdgeInsets.only(bottom: 5,left: 10),  
                      margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10,top: 8),
                      decoration: BoxDecoration(
                        color: priorityColor[snapshot.data![index].taskPriority],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 7,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 3
                          )
                        ]
                     ),
                      child: Column(
                        children: [
                          ListTile(
                            splashColor: Colors.white,
                            contentPadding:const  EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                            onTap: (){
                              print("home screen wali id: ${snapshot.data![index].id}");
                              
                              Navigator.pushReplacement(
                                context, 
                                
                                MaterialPageRoute(builder: (context)=> NewTask(editTask: true, todo: Todo(id:snapshot.data![index].id, title: snapshot.data![index].title, description: snapshot.data![index].description, taskPriority: snapshot.data![index].taskPriority, category: snapshot.data![index].category, status: snapshot.data![index].status),
                                  )
                                )
                              );
                              
                            },
                            leading: Icon(categoryIcons[snapshot.data![index].category],
                              size: 32,),
                                  
                            title: Text(snapshot.data![index].title,
                              style: Theme.of(context).textTheme.labelMedium),
                            subtitle: Text(snapshot.data![index].description,
                              style: Theme.of(context).textTheme.labelSmall,),
                            trailing: Checkbox(
                              value: snapshot.data![index].status, 
                              onChanged: (newvalue){
                                setState(() {
                                  statusTask(snapshot.data![index], newvalue!,snapshot.data![index].id!);
                                });
                              }
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 0.8,
                          ),
                          Row(
                            children: [
                              Text("Priority: ${snapshot.data![index].taskPriority.name}"),
                              Text(" | Date: ${snapshot.data![index].category.name}")
                            ],
                          )
                        ],
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
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>NewTask(editTask: false,)));
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