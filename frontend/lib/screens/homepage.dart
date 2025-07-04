import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import 'create.dart';
import 'edit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final pdata = productProvider.products;

    return Scaffold(
      appBar: AppBar(title: const Text("Product List")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CreateProduct()),
                    );
                  },
                  child: const Text("CREATE"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pdata.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(pdata[index].productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: ${pdata[index].price}"),
                            Text("Stock: ${pdata[index].stock}"),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPage(data: pdata[index]),
                                    ),
                                  );

                                  if (updated == true) {
                                    await Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .fetchProducts();
                                    setState(() {});
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await productProvider
                                      .deleteProduct(pdata[index].productId!);
                                  setState(() {});
                                },
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
