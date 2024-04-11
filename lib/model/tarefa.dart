import "./prioridade.dart";

class Task {
  String id;
  String titulo;
  Prioridade prioridade;
  String? descricao;
  String? observacao;
  DateTime dataEscolhida;
  DateTime dataCriacao;

  Task(
      {required this.id,
      required this.titulo,
      required this.dataEscolhida,
      this.prioridade = Prioridade.baixa,
      this.descricao,
      this.observacao})
      : dataCriacao = DateTime.now();
}
