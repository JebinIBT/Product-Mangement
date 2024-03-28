import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productName;
  final String productDescription;
  final double productPrice;
  final String quantity;

  const ProductDetailsPage({
    Key? key,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red[400],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/splash.png',
                  height: 200,
                  width: 200,
                ),
              ),
              Text(
                productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              Text(
                productDescription,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10.0),
              Text(
                '\$${productPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(
                thickness: 2,
              ),
              Text(
                "QR Code",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: PrettyQrView.data(data: productName),
              )
            ],
          ),
        ),
      ),
    );
  }
}
