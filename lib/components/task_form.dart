import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/prioridade.dart';

// ignore: must_be_immutable
class FormTarefa extends StatefulWidget {
  Function(String, DateTime, Prioridade, String?, String?) onSubmit;
  FormTarefa(this.onSubmit, {super.key});

  @override
  State<FormTarefa> createState() => _FormTarefaState();
}

class _FormTarefaState extends State<FormTarefa> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _observacaoController = TextEditingController();
  Prioridade _dropdownValue = Prioridade.baixa;
  DateTime _dataSelecionada = DateTime.now();

  /// Retorna os dados para o widget pai por callback
  _submitForm() {
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;
    final observacao = _observacaoController.text;

    if (titulo.isEmpty) {
      return;
    }
    widget.onSubmit(
        titulo, _dataSelecionada, _dropdownValue, descricao, observacao);
  }

  /// Widget para seleção de prioridade
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
          _dropdownValue = p!;
        });
      },
      value: _dropdownValue,
    );
  }

  /// Abre o widget de seleção de data
  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime(2025))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dataSelecionada = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            controller: _tituloController,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: _descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
          ),
          TextField(
            controller: _observacaoController,
            decoration: const InputDecoration(labelText: 'Observação'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('Prioridade selecionada: ${_dropdownValue.name}'),
                ),
                _dropdown(),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    'Data selecionada ${DateFormat('dd/MM/yyyy').format(_dataSelecionada)}'),
              ),
              TextButton(
                  onPressed: _showDatePicker,
                  child: const Text('Selecionar data'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: _submitForm, child: const Text('Cadastrar tarefa')),
          )
        ],
      ),
    );
  }
}
