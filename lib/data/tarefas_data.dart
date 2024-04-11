import 'package:todo_list/model/prioridade.dart';
import 'package:todo_list/model/tarefa.dart';

List<Task> tasks = [
  Task(
      id: 't0',
      titulo: 'Estudar',
      dataEscolhida: DateTime.now().add(const Duration(days: 2)),
      prioridade: Prioridade.baixa),
  Task(
      id: 't1',
      titulo: 'Jogar',
      dataEscolhida: DateTime.now().add(const Duration(days: 1)),
      prioridade: Prioridade.baixa),
  Task(
    id: 't2',
    titulo: 'Ir ao mercado',
    prioridade: Prioridade.normal,
    dataEscolhida: DateTime.now().add(const Duration(days: 5)),
  ),
  Task(
      id: 't3',
      titulo: 'Limpar a casa',
      dataEscolhida: DateTime.now().add(const Duration(days: 14)),
      prioridade: Prioridade.normal,
      descricao: 'Limpar o piso, móveis e banheiro',
      observacao: 'Comprar água sanitária'),
  Task(
      id: 't4',
      titulo: 'Viajar',
      dataEscolhida: DateTime.now(),
      prioridade: Prioridade.alta,
      observacao: "Portão 4"),
  Task(
      id: 't5',
      titulo: 'Visitar seu João',
      dataEscolhida: DateTime.now().subtract(const Duration(days: 2)),
      observacao: "Rua 12, 1523"),
];
