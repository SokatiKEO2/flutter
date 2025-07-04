import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../utils/api.dart';

class EditPage extends StatefulWidget {
  final Product data;

  const EditPage({super.key, required this.data});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.data.productName;
    _priceController.text = widget.data.price.toString();
    _stockController.text = widget.data.stock.toString();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product")),
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
                  var updatedData = {
                    "productName": name,
                    "price": price.toString(),
                    "stock": stock.toString(),
                  };

                  await Api.updateProduct(widget.data.productId, updatedData);

                  Navigator.pop(context, true);
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
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
