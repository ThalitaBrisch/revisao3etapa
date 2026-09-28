class Pedido {
  final int? id;
  final String cliente;
  final String prato;
  final int quantidade;
  final double valorUnitario;
  final double total;
  final String classificacao;
  final String status;

  Pedido({
    this.id,
    required this.cliente,
    required this.prato,
    required this.quantidade,
    required this.valorUnitario,
    required this.total,
    required this.classificacao,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente': cliente,
      'prato': prato,
      'quantidade': quantidade,
      'valor_unitario': valorUnitario,
      'total': total,
      'classificacao': classificacao,
      'status': status,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      cliente: map['cliente'],
      prato: map['prato'],
      quantidade: map['quantidade'],
      valorUnitario: map['valor_unitario'],
      total: map['total'],
      classificacao: map['classificacao'],
      status: map['status'],
    );
  }
}
