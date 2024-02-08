import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/task/bloc/bloc/crud_bloc.dart';
import '../widgets/custom_text.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String selectedStatus = 'Pending';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CustomText(text: 'order'.toUpperCase()),
              TextFormField(controller: _title),
              CustomText(text: 'location'.toUpperCase()),
              TextFormField(controller: _description),
              CustomText(text: 'Status'.toUpperCase()),
              BlocBuilder<CrudBloc, CrudState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_title.text.isNotEmpty &&
                          _description.text.isNotEmpty) {
                        context.read<CrudBloc>().add(
                              AddTodo(
                                title: _title.text,
                                isImportant: false,
                                number: 0,
                                description: _description.text,
                                createdTime: DateTime.now(),
                                status: selectedStatus, // Include status
                              ),
                            );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text("Task successfully"),
                        ));
                        context.read<CrudBloc>().add(const FetchTodos());
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Title and description fields must not be blank"
                                  .toUpperCase()),
                        ));
                      }
                    },
                    child: const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
