import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';


  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false).findbyID(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      /*appBar: AppBar(
        title: Text(loadedProduct.title),
        backgroundColor: Colors.teal[700],
      ),*/
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title,
                style: TextStyle(color: Colors.cyan),
                textAlign: TextAlign.left,
              ),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,)
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 15),
                Text(
                  'Price: \$${loadedProduct.price.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.grey, fontSize: 40),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child:
                    Text('${loadedProduct.description}', textAlign: TextAlign.center, softWrap: true,
                      style: TextStyle(fontSize: 25)
                    )
                ),
                SizedBox(height: 700),
              ]),
          ),
        ],
      ),
    );
  }
}
