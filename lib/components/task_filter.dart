import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/prioridade.dart';

// ignore: must_be_immutable
class FormFilter extends StatefulWidget {
  Function(DateTime?, DateTime?, Prioridade?) onFilter;
  FormFilter(this.onFilter, {super.key});

  @override
  State<FormFilter> createState() => _FormFilterState();
}

class _FormFilterState extends State<FormFilter> {
  Prioridade? _prioridade;
  DateTime? _dataCriacao;
  DateTime? _dataTarefa;

  @override
  Widget build(BuildContext context) {
    /// Retorna os dados para o widget pai por callback
    _submitForm() {
      widget.onFilter(_dataCriacao, _dataTarefa, _prioridade);
      Navigator.pop(context);
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
            _prioridade = p;
          });
        },
        value: _prioridade,
      );
    }

    /// Abre o widget de seleção de data
    _showDatePicker(bool isCreation) {
      showDatePicker(
              context: context,
              firstDate: DateTime(2024),
              lastDate: DateTime(2025))
          .then((pickedDate) {
        setState(() {
          if (isCreation) {
            _dataCriacao = pickedDate;
          } else {
            _dataTarefa = pickedDate;
          }
        });
      });
    }

    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      'Prioridade selecionada: ${_prioridade == null ? "Nenhuma" : _prioridade!.name}'),
                ),
                _dropdown(),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    'Data de criação: ${_dataCriacao == null ? "Nenhuma" : DateFormat('dd/MM/yyyy').format(_dataCriacao!)}'),
              ),
              TextButton(
                  onPressed: () => _showDatePicker(true),
                  child: const Text('Selecionar data'))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                    'Data da tarefa: ${_dataTarefa == null ? "Nenhuma" : DateFormat('dd/MM/yyyy').format(_dataTarefa!)}'),
              ),
              TextButton(
                  onPressed: () => _showDatePicker(false),
                  child: const Text('Selecionar data'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: _submitForm, child: const Text('Filtrar')),
          )
        ],
      ),
    );
  }
}
