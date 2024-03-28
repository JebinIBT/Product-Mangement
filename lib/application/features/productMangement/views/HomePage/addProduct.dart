import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/application/features/productMangement/Product_bloc/add_product_bloc.dart';
import 'package:machinetest/application/features/productMangement/models/product_model.dart';
import 'package:machinetest/application/features/productMangement/views/Common%20Widget/commonTextfield.dart';
import 'package:machinetest/application/features/productMangement/views/Common%20Widget/commonbutton.dart';

class AddProductViewWrapper extends StatelessWidget {
  const AddProductViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddProductBloc(),
      child: AddProducts(),
    );
  }
}

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  AddProductBloc productBloc = AddProductBloc();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController measurementController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    productNameController.dispose();
    measurementController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddProductBloc, AddProductState>(
        builder: (context, state) {
      if (state is AddProductLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      }

      if (state is AddProductSuccess) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Product",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.red[400],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Add Product",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(
                  height: 50,
                ),
                CustomTextfield(
                  controller: productNameController,
                  hintText: 'Product Name',
                  obscureText: false,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextfield(
                  controller: descriptionController,
                  hintText: 'Product Decription',
                  obscureText: false,
                  maxlines: 3,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextfield(
                  controller: measurementController,
                  hintText: 'Quantity',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextfield(
                  controller: priceController,
                  hintText: 'Price',
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                CommonButton(
                  title: 'Submit ',
                  onClick: () {
                    addProductToFirestore();

                    Navigator.pushNamed(context, '/home');
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void addProductToFirestore() {
    Product product = Product(
      id: UniqueKey().toString(),
      name: productNameController.text,
      description: descriptionController.text,
      quantity: measurementController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
    );
    productBloc.add(AddProduct(product));
  }
}
