import 'package:flutter/material.dart';
import 'package:to_do_list/database/database.dart';
import 'package:to_do_list/model/todo.dart';
import 'package:to_do_list/screen/home_screen.dart';
import 'package:to_do_list/widgets/constants.dart';

// ignore: must_be_immutable
class NewTask extends StatefulWidget {
  NewTask({super.key,required this.editTask,this.todo});

  Todo? todo;

  bool editTask;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Category _selectedCategory = Category.food;
  Priority _selectedPriority = Priority.low;
  DateTime? _selectedDate;
  DBHelper dbHelper = DBHelper();
  final _formKey = GlobalKey<FormState>();
  late Future<List<Todo>> allTasks;

  

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    if(widget.editTask){
      titleController= TextEditingController(text: widget.todo!.title);
      descriptionController= TextEditingController(text: widget.todo!.description);
      _selectedCategory= widget.todo!.category;
      _selectedPriority= widget.todo!.taskPriority;
    }
  }

  loadData() async{
    allTasks = dbHelper.getDataList();
  }


  void _presentDatePicker() async{

    final now = DateTime.now();
    final lastDate = DateTime(now.year+1,now.month,now.day);
    final pickedDate = await showDatePicker(
      initialDate: now,
      context: context, 
      firstDate: now, 
      lastDate: lastDate
    );
    setState(() {
      
      _selectedDate = pickedDate;
    });
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.editTask ? "Edit Todo" : "Add new Todo" ,
          style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 30, 20, keyboardSpace + 18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                maxLength: 15,
                decoration: InputDecoration(
                  hintText: "Title...",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      strokeAlign: 1.5
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      strokeAlign: 1.5
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      strokeAlign: 1.5
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      strokeAlign: 1.5
                    )
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Please Enter Title!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                maxLength: 60,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description...",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      strokeAlign: 1.5
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      strokeAlign: 1.5
                    )
                  )
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  DropdownButton(
                    value: _selectedCategory,
                    items: Category.values.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase()))).toList(), 
                    onChanged: (value){
                      if(value ==null){
                        return;
                    }
                    setState(() {
                      _selectedCategory = value;
                      });
                    }
                  ),
                  const Spacer(),
                  DropdownButton(
                    value: _selectedPriority,
                    items: Priority.values.map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(
                          priority.name.toUpperCase()))).toList(), 
                    onChanged: (value){
                      if(value == null){
                        return;
                    }
                    setState(() {
                      _selectedPriority = value;
                      });
                    }
                  ),
                  const Spacer(),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){
                        _presentDatePicker();
                      },
                      icon: const Icon(Icons.calendar_month,
                        color: Colors.grey,
                        size: 30,
                      )),
                      Text(_selectedDate == null ? "No date Selected" : formatter.format(_selectedDate!)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(hintText: 'Cancel', containerColor: Colors.redAccent,nextScreen: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  }),
                  const SizedBox(width: 10,),
                  CustomButton(hintText: widget.editTask ? "Update" : "Add New Task",containerColor: Colors.green,nextScreen: (){
                    if(_formKey.currentState!.validate() && _selectedDate != null){
                      if(!widget.editTask){
                      try{
                      dbHelper.insert(Todo(
                        title: titleController.text, 
                        description: descriptionController.text, 
                        date: _selectedDate!, 
                        taskPriority: _selectedPriority, 
                        category: _selectedCategory, 
                        status: false
                        )
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                    }
                    catch(e){
                      // error occured
                    }
                   }
                    else{
                      try{
                      dbHelper.update(
                        widget.todo!.id!,
                        Todo(
                          id:widget.todo!.id, 
                          title: titleController.text, 
                          description: descriptionController.text, 
                          taskPriority: _selectedPriority, 
                          category: _selectedCategory, 
                          status: widget.todo!.status, 
                          date: _selectedDate!
                          )
                        );
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                      }
                      catch(e){
                        // catching error
                      }
                      }
                    }
                    else{
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Date and Title fields are mandatory!"),
                          duration: Duration(milliseconds: 2000),
                        )
                      );
                      
                    }
                  }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}