import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/models/user.dart';
import 'package:task/task/bloc/bloc/crud_bloc.dart';
import 'package:task/task/page/add_todo.dart';
import 'package:task/task/page/details_page.dart';

class TaskPage extends StatelessWidget {
  final User? user;

  const TaskPage({Key? key, this.user}) : super(key: key);

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green; // Change color for completed tasks
      case 'started':
        return Colors.orange; // Change color for started tasks
      case 'paused':
        return Colors.yellow; // Change color for paused tasks
      case 'pending':
      default:
        return Colors.blue; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.username ?? ''),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(user?.username.substring(0, 1) ?? ''),
              ),
            ),
            ListTile(
              title: Text('Task 1'),
              onTap: () {
                // Handle task 1 action
              },
            ),
            ListTile(
              title: Text('Task 2'),
              onTap: () {
                // Handle task 2 action
              },
            ),
          ],
        ),
      ),
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
                                final task = state.todo[i];
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<CrudBloc>()
                                        .add(FetchSpecificTodo(id: task.id!));
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
                                      color: getStatusColor(task.status),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              task.title.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Status: ${task.status}',
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
                                                            id: task.id!));
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
