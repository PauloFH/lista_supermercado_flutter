import 'dart:convert';
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
      quantidade: map['quantidade'] ?? 0.0,
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
          .map((produtoString) => Produto.fromMap(json.decode(produtoString)))
          .toList();
      _calcularTotalFeira();
      setState(() {});
    }
  }

  Future<void> _saveProdutos() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> produtosStringList = produtos.map((produto) => json.encode(produto.toMap())).toList();
    prefs.setStringList('produtos', produtosStringList);
  }

  void _adicionarProduto() {
    setState(() {
      produtos.add(Produto(
        nome: nomeController.text,
        quantidade: double.tryParse(quantidadeController.text) ?? 0.0,
        precoUnitario: double.tryParse(precoUnitarioController.text) ?? 0.0,
        precoTotal: (double.tryParse(precoUnitarioController.text) ?? 0.0) * (double.tryParse(quantidadeController.text) ?? 0.0),
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Total da Feira: R\$ ${totalFeira.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(produtos[index].nome, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'Qtd: ${produtos[index].quantidade} \n Preço Total: R\$ ${produtos[index].precoTotal.toStringAsFixed(2)} \n Preço Unitário: R\$ ${produtos[index].precoUnitario.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removerProduto(index),
                  ),
                  onTap: () => _editarProduto(index),
                );
              },
              separatorBuilder: (context, index) => const Divider(color: Colors.white24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(labelText: 'Produto'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: quantidadeController,
                        decoration: const InputDecoration(labelText: 'Quantidade'),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: precoUnitarioController,
                        decoration: const InputDecoration(labelText: 'Preço Unitário'),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _adicionarProduto,
                  child: const Text('Adicionar/Atualizar'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
