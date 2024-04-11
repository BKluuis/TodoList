import 'dart:math';

import 'package:todo_list/data/tarefas_data.dart';
import 'package:todo_list/components/task_filter.dart';
import 'package:todo_list/components/task_form.dart';
import 'package:todo_list/components/task_list.dart';
import 'package:todo_list/model/prioridade.dart';
import 'package:todo_list/model/tarefa.dart';
import 'package:flutter/material.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  List<bool Function(Task)> _filterList = [];

  _newTask(
      String title, DateTime date, Prioridade prio, String? desc, String? obs) {
    Task newTask = Task(
        id: Random().nextInt(9999).toString(),
        titulo: title,
        prioridade: prio,
        dataEscolhida: date,
        descricao: desc,
        observacao: obs);

    setState(() {
      tasks.add(newTask);
    });

    Navigator.of(context).pop();
  }

  _setFilterList(
      DateTime? creationDate, DateTime? taskDate, Prioridade? priority) {
    setState(() {
      _filterList = [];
      if (creationDate != null) {
        _filterList.add((t) => t.dataCriacao == creationDate);
      }
      if (taskDate != null) {
        _filterList.add((t) => t.dataEscolhida == taskDate);
      }
      if (priority != null) {
        _filterList.add((t) => t.prioridade == priority);
      }
    });
  }

  //Filter Modal
  _openFilterModal(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (_) => FormFilter(_setFilterList));
  }

  //Form modal
  _openTaskFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return FormTarefa(_newTask);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 100,
        title: const Text('To Do List'),
        actions: [
          IconButton(
              onPressed: () => _openTaskFormModal(context),
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () => _openFilterModal(context),
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TaskList(taskList: tasks, filterList: _filterList),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskFormModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
