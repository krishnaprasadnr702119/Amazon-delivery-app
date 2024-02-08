import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/task/bloc/bloc/crud_bloc.dart';
import 'package:task/task/page/add_todo.dart';
import 'package:task/task/page/details_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AddTodoPage()),
          );
        },
      ),
      body: BlocBuilder<CrudBloc, CrudState>(
        builder: (context, state) {
          if (state is CrudInitial) {
            context.read<CrudBloc>().add(const FetchTodos());
          }
          if (state is DisplayTodos) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Add Task'.toUpperCase(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    state.todo.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(8),
                              itemCount: state.todo.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    context.read<CrudBloc>().add(
                                        FetchSpecificTodo(
                                            id: state.todo[i].id!));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            const DetailsPage()),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 14),
                                    child: Card(
                                      elevation: 10,
                                      color: Colors.blue,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              state.todo[i].title.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Status: ${state.todo[i].status}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CrudBloc>()
                                                        .add(DeleteTodo(
                                                            id: state
                                                                .todo[i].id!));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        content: Text(
                                                            "Deleted todo"),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Text(''),
                  ],
                ),
              ),
            );
          }
          return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
