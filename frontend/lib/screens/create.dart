import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../provider/product_provider.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Product")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                final name = _productNameController.text.trim();
                final price = double.tryParse(_priceController.text) ?? -1;
                final stock = int.tryParse(_stockController.text) ?? -1;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product name is required")),
                  );
                  return;
                }

                if (price < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Price cannot be negative or empty")),
                  );
                  return;
                }

                if (stock < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Stock cannot be negative or empty")),
                  );
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                try {
                  final product = Product(
                    null,
                    price,
                    name,
                    stock,
                  );

                  await productProvider.createProduct(product);

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
