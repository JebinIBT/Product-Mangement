import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machinetest/application/features/productMangement/views/productDetailspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late List<DocumentSnapshot> _allProducts = [];
  late List<DocumentSnapshot> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getAllProducts();
  }

  void _getAllProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      _allProducts = querySnapshot.docs;
      _displayedProducts = List.from(_allProducts);
    });
  }

  void _deleteProduct(String productId) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete()
        .then((value) {
      // Product deleted successfully
      _getAllProducts(); // Refresh the product list after deletion
    }).catchError((error) {
      print("Error deleting product: $error");
    });
  }

  void _editProduct(String productId, Map<String, dynamic> newData) {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update(newData)
        .then((value) {
      // Product updated successfully
      _getAllProducts(); // Refresh the product list after update
    }).catchError((error) {
      print("Error updating product: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[400],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Clear the previous search results
              _searchController.clear();
              _updateDisplayedProducts(_allProducts);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by product name',
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                _searchProducts(value);
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Products in Firestore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _displayedProducts.isEmpty
                  ? Center(child: Text('No products found'))
                  : ListView.builder(
                      itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> productData =
                            _displayedProducts[index].data()
                                as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  productName: productData['name'],
                                  productDescription:
                                      productData['description'],
                                  productPrice: productData['price'],
                                  quantity: productData['quantity'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(productData['name']),
                                //  subtitle: Text(productData['description']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _showEditProductDialog(
                                            productData['id'], productData);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(
                                            productData['id']);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchProducts(String query) {
    List<DocumentSnapshot> results = _allProducts.where((product) {
      String name = product['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
    _updateDisplayedProducts(results);
  }

  void _updateDisplayedProducts(List<DocumentSnapshot> products) {
    setState(() {
      _displayedProducts = List.from(products);
    });
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(
      String productId, Map<String, dynamic> productData) {
    TextEditingController nameController =
        TextEditingController(text: productData['name']);
    TextEditingController descriptionController =
        TextEditingController(text: productData['description']);
    TextEditingController priceController =
        TextEditingController(text: productData['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Product Description'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Product Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String newName = nameController.text;
                String newDescription = descriptionController.text;
                double newPrice = double.tryParse(priceController.text) ?? 0.0;

                _editProduct(productId, {
                  'name': newName,
                  'description': newDescription,
                  'price': newPrice,
                });

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
