import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Produto {
  String nome;
  double quantidade;
  double precoUnitario;
  double precoTotal;

  Produto({
    required this.nome,
    required this.quantidade,
    required this.precoUnitario,
    required this.precoTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
      'precoTotal': precoTotal,
    };
  }

factory Produto.fromMap(Map<String, dynamic> map) {
  return Produto(
    nome: map['nome'] ?? '',
    quantidade: map['quantidade'] ?? 0,
    precoUnitario: map['precoUnitario'] ?? 0.0,
    precoTotal: map['precoTotal'] ?? 0.0,
  );
}
}

class PlanilhaPage extends StatefulWidget {
  @override
  _PlanilhaPageState createState() => _PlanilhaPageState();
}

class _PlanilhaPageState extends State<PlanilhaPage> {
  List<Produto> produtos = [];
  TextEditingController nomeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController precoUnitarioController = TextEditingController();
  TextEditingController precoTotalController = TextEditingController();
  double totalFeira = 0.0;

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? produtosStringList = prefs.getStringList('produtos');
    if (produtosStringList != null) {
      produtos = produtosStringList
          .map((produtoString) => Produto.fromMap(Map<String, dynamic>.from(Uri.parse(produtoString).queryParameters)))
          .toList();
      _calcularTotalFeira();
      setState(() {});
    }
  }

  Future<void> _saveProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> produtosStringList = produtos.map((produto) => Uri(queryParameters: produto.toMap()).toString()).toList();
    prefs.setStringList('produtos', produtosStringList);
  }

  void _adicionarProduto() {
    setState(() {
      produtos.add(Produto(
        nome: nomeController.text,
        quantidade: double.parse(quantidadeController.text),
        precoUnitario: double.parse(precoUnitarioController.text),
        precoTotal: double.parse(precoUnitarioController.text) * double.parse(quantidadeController.text),
      ));
      _calcularTotalFeira();
      _limparCampos();
      _saveProdutos();
    });
  }

  void _editarProduto(int index) {
    setState(() {
      nomeController.text = produtos[index].nome;
      quantidadeController.text = produtos[index].quantidade.toString();
      precoUnitarioController.text = produtos[index].precoUnitario.toString();
      precoTotalController.text = produtos[index].precoTotal.toString();
      produtos.removeAt(index);
      _calcularTotalFeira();
      _saveProdutos();
    });
  }

  void _removerProduto(int index) {
    setState(() {
      produtos.removeAt(index);
      _calcularTotalFeira();
      _saveProdutos();
    });
  }

  void _calcularTotalFeira() {
    totalFeira = produtos.fold(0.0, (sum, item) => sum + item.precoTotal);
  }

  void _limparCampos() {
    nomeController.clear();
    quantidadeController.clear();
    precoUnitarioController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(produtos[index].nome),
                subtitle: Text(
                  'Qtd: ${produtos[index].quantidade} - Preço Total: R\$ ${produtos[index].precoTotal.toStringAsFixed(2)} -\n Preço Unitário: R\$ ${produtos[index].precoUnitario.toStringAsFixed(2)}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removerProduto(index),
                ),
                onTap: () => _editarProduto(index),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Produto'),
              ),
              TextField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: precoUnitarioController,
                decoration: InputDecoration(labelText: 'Preço Unitário'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Adicionar/Atualizar'),
                onPressed: _adicionarProduto,
              ),
              SizedBox(height: 20),
              Text(
                'Total da Feira: R\$ ${totalFeira.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
