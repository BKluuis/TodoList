import "package:todo_list/model/prioridade.dart";
import "package:todo_list/model/tarefa.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class TaskView extends StatefulWidget {
  final Task task;
  final Function(
          String, String, DateTime, DateTime, Prioridade, String?, String?)
      onSubmit;
  final Function(Task) onDelete;

  TaskView(
      {required this.task, required this.onSubmit, required this.onDelete});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _obsController;
  late Prioridade _priority;
  late DateTime _selectedDate;
  late DateTime _creationDate;

  _submit() {
    if (_titleController.text.isEmpty) {
      return;
    }
    widget.onSubmit(widget.task.id, _titleController.text, _selectedDate,
        _creationDate, _priority, _descController.text, _obsController.text);
  }

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.titulo);
    _descController = TextEditingController(text: widget.task.descricao);
    _obsController = TextEditingController(text: widget.task.observacao);
    _priority = widget.task.prioridade;
    _selectedDate = widget.task.dataEscolhida;
    _creationDate = widget.task.dataCriacao;
  }

  @override
  Widget build(BuildContext context) {
    Widget _dropdown() {
      return DropdownButton(
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        items: Prioridade.values
            .map((p) => DropdownMenuItem(
                value: p,
                child: Text(
                    "${p.name[0].toUpperCase()}${p.name.substring(1).toLowerCase()}")))
            .toList(),
        onChanged: (Prioridade? p) {
          setState(() {
            _priority = p!;
          });
        },
        value: _priority,
      );
    }

    _showDatePicker(Function(DateTime) state) {
      showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2024),
              lastDate: DateTime(2025))
          .then((pickedDate) {
        if (pickedDate == null) {
          return;
        }
        state(pickedDate);
      });
    }

    return Scaffold(
        appBar: AppBar(title: const Text('To Do List'), actions: [
          IconButton(
              onPressed: () {
                widget.onDelete(widget.task);
              },
              icon: const Icon(Icons.delete))
        ]),
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _obsController,
                decoration: const InputDecoration(labelText: 'Observação'),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Prioridade selecionada: ${_priority.name}'),
                    ),
                    _dropdown(),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        'Data selecionada ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                  ),
                  TextButton(
                      onPressed: () => _showDatePicker((date) => setState(() {
                            _selectedDate = date;
                          })),
                      child: const Text('Selecionar data'))
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        'Data de criação ${DateFormat('dd/MM/yyyy').format(_creationDate)}'),
                  ),
                  TextButton(
                      onPressed: () => _showDatePicker((date) => setState(() {
                            _creationDate = date;
                          })),
                      child: const Text('Selecionar data'))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _submit, child: const Text('Salvar')),
              )
            ],
          ),
        ));
  }
}
