import 'package:flutter/material.dart';

void main() {
  runApp(const PizzariaApp());
}

class PizzariaApp extends StatelessWidget {
  const PizzariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizati Pizzaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: const Color(0xFF008C45),
          secondary: const Color(0xFFCD212A),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF008C45),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFCD212A),
        ),
      ),
      home: const PizzaMenuPage(),
    );
  }
}

class Pizza {
  final String nome;
  final String descricao;
  final String imagem;
  final double preco;

  Pizza({required this.nome, required this.descricao, required this.imagem, required this.preco});
}

final List<Pizza> pizzas = [
  Pizza(
    nome: 'Marguerita',
    descricao: 'Molho de tomate, mussarela, tomate e manjericão fresco.',
    imagem: 'assets/images/pizza-marguerita.jpg',
    preco: 39.90,
  ),
  Pizza(
    nome: 'Pepperoni',
    descricao: 'Molho de tomate, mussarela e pepperoni.',
    imagem: 'assets/images/pizza-pepperoni.jpg',
    preco: 44.90,
  ),
  Pizza(
    nome: 'Quatro Queijos',
    descricao: 'Molho de tomate, mussarela, parmesão, gorgonzola e catupiry.',
    imagem: 'assets/images/pizza-queijos.jpg',
    preco: 47.90,
  ),
  Pizza(
    nome: 'Calabresa',
    descricao: 'Molho de tomate, mussarela, calabresa, e catupiry.',
    imagem: 'assets/images/pizza-calabresa.png',
    preco: 42.90,
  ),
];

class PizzaMenuPage extends StatefulWidget {
  const PizzaMenuPage({super.key});

  @override
  State<PizzaMenuPage> createState() => _PizzaMenuPageState();
}

class _PizzaMenuPageState extends State<PizzaMenuPage> {
  final List<Pizza> carrinho = [];

  void adicionarAoCarrinho(Pizza pizza) {
    setState(() {
      carrinho.add(pizza);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('${pizza.nome} adicionada ao carrinho!')),
          ],
        ),
        backgroundColor: const Color(0xFF008C45),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void abrirCarrinho() {
    if (carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.shopping_cart_outlined, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(child: Text('Seu carrinho está vazio. Adicione algumas pizzas!')),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CarrinhoPage(
          carrinho: carrinho,
          onPedidoFinalizado: limparCarrinho,
        ),
      ),
    );
  }

  void limparCarrinho() {
    setState(() {
      carrinho.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizati Pizzaria'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: abrirCarrinho,
              ),
              if (carrinho.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFCD212A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '${carrinho.toSet().length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  color: Color(0xFF008C45),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cardápio',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008C45),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (context, index) {
                final pizza = pizzas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            pizza.imagem,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pizza.nome,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                pizza.descricao,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'R\$ ${pizza.preco.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF008C45),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFCD212A),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      minimumSize: const Size(60, 24),
                                      textStyle: const TextStyle(fontSize: 10),
                                    ),
                                    onPressed: () => adicionarAoCarrinho(pizza),
                                    child: const Text('Adicionar'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CarrinhoPage extends StatefulWidget {
  final List<Pizza> carrinho;
  final Function() onPedidoFinalizado;
  const CarrinhoPage({super.key, required this.carrinho, required this.onPedidoFinalizado});

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late Map<Pizza, int> quantidadeItens;

  @override
  void initState() {
    super.initState();
    quantidadeItens = {};
    for (var pizza in widget.carrinho) {
      quantidadeItens[pizza] = (quantidadeItens[pizza] ?? 0) + 1;
    }
  }

  void aumentarQuantidade(Pizza pizza) {
    setState(() {
      quantidadeItens[pizza] = (quantidadeItens[pizza] ?? 0) + 1;
    });
  }

  void diminuirQuantidade(Pizza pizza) {
    setState(() {
      if (quantidadeItens[pizza] != null && quantidadeItens[pizza]! > 1) {
        quantidadeItens[pizza] = quantidadeItens[pizza]! - 1;
      } else {
        quantidadeItens.remove(pizza);
      }
    });
  }

  double get total {
    return quantidadeItens.entries.fold(0, (soma, entry) {
      return soma + (entry.key.preco * entry.value);
    });
  }

  int get totalItens {
    return quantidadeItens.values.fold(0, (soma, quantidade) => soma + quantidade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: widget.carrinho.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Seu carrinho está vazio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione algumas pizzas deliciosas!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Ver Cardápio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008C45),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: quantidadeItens.length,
              itemBuilder: (context, index) {
                final pizza = quantidadeItens.keys.elementAt(index);
                final quantidade = quantidadeItens[pizza]!;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            pizza.imagem,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pizza.nome,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'R\$ ${pizza.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF008C45),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => diminuirQuantidade(pizza),
                                    icon: const Icon(Icons.remove_circle_outline, size: 18),
                                    color: const Color(0xFFCD212A),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                  ),
                                  Text(
                                    '$quantidade',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => aumentarQuantidade(pizza),
                                    icon: const Icon(Icons.add_circle_outline, size: 18),
                                    color: const Color(0xFF008C45),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$totalItens itens',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  'R\$ ${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008C45),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(child: Text('Pedido realizado com sucesso!')),
                        ],
                      ),
                      backgroundColor: const Color(0xFF008C45),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  if (context.mounted) {
                    widget.onPedidoFinalizado();
                  }
                },
                child: const Text(
                  'Finalizar Pedido',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
