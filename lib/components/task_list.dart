// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/model/prioridade.dart';
import 'package:todo_list/view/task_view.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../model/tarefa.dart';

// ignore: must_be_immutable
class TaskList extends StatefulWidget {
  List<Task> taskList;
  List<bool Function(Task)> filterList;

  TaskList({required this.taskList, required this.filterList});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  /// Retorna uma lista filtrada de itens dado uma lista de itens e uma lista de filtros
  List<T> _filter<T>(List<T> items, List<bool Function(T)> filters) {
    List<T> filteredList = items;

    if (filters.isEmpty || items.isEmpty) {
      return items;
    }

    for (var filter in filters) {
      filteredList = filteredList.where(filter).toList();
    }
    return filteredList;
  }

  /// Abre um widget de pop-up que realiza uma ação "onConfirm" ao concluir
  _showDialog(Task task, Function() onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
              "Deseja realmente excluir essa tarefa? Esta ação não poderá ser desfeita"),
          actions: [
            ElevatedButton(
                onPressed: onConfirm, child: const Text("Confirmar")),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"))
          ],
        );
      },
    );
  }

  /// Cria widget ListItem com base em uma task
  ListTile _listItemFactory(Task task) {
    Icon leadingIcon;

    if (task.prioridade == Prioridade.baixa) {
      leadingIcon = const Icon(
        Icons.keyboard_arrow_up,
        color: Colors.green,
      );
    } else if (task.prioridade == Prioridade.normal) {
      leadingIcon = const Icon(
        Icons.keyboard_double_arrow_up,
        color: Colors.amber,
      );
    } else {
      leadingIcon = const Icon(
        Icons.warning_rounded,
        color: Colors.red,
      );
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: leadingIcon,
      ),
      title: Text(task.titulo),
      subtitle: Text(DateFormat('d MMM y').format(task.dataEscolhida)),
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () => _showDialog(
          task,
          () {
            setState(() {
              widget.taskList.remove(task);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  /// Substitui uma task na lista com as informações fornecidas
  _updateTask(
      String id,
      String title,
      DateTime selectedDate,
      DateTime creationDate,
      Prioridade priority,
      String? description,
      String? observation) {
    Task oldTask = widget.taskList.where((element) => element.id == id).first;
    int index = widget.taskList.indexOf(oldTask);

    Task newTask = Task(
        id: id,
        titulo: title,
        dataEscolhida: selectedDate,
        descricao: description,
        observacao: observation,
        prioridade: priority);

    newTask.dataCriacao = creationDate;

    setState(() {
      widget.taskList[index] = newTask;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = _filter(widget.taskList, widget.filterList);

    _taskColor(Task task) {
      if (DateTime.now().difference(task.dataEscolhida).isNegative) {
        return Theme.of(context).colorScheme.secondary;
      } else if (DateTime.now().difference(task.dataEscolhida).inDays == 0) {
        return Theme.of(context).colorScheme.primary;
      } else {
        return Theme.of(context).colorScheme.tertiary;
      }
    }

    return SizedBox(
      height: 600,
      child: filteredTasks.isEmpty
          ? const Center(child: Text("Nenhuma tarefa cadastrada"))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                    color: _taskColor(task),
                    // DateTime.now().difference(task.dataEscolhida).isNegative
                    //     ? Theme.of(context).colorScheme.secondary
                    //     : Theme.of(context).colorScheme.tertiary,
                    child: InkWell(
                        child: _listItemFactory(task),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => TaskView(
                                    task: task,
                                    onSubmit: _updateTask,
                                    onDelete: (t) => _showDialog(
                                          t,
                                          () {
                                            setState(() {
                                              widget.taskList.remove(task);
                                            });
                                            Navigator.popUntil(context,
                                                (route) => route.isFirst);
                                          },
                                        ))))));
              }),
    );
  }
}
