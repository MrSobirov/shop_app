import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  /*final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);*/

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('images/box.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover
              ),
            ),
          ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: Colors.redAccent,
            onPressed: () => product.toggleFavoriteStatus(authData.token, authData.userId),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10,),
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart_rounded, color: Theme.of(context).accentColor,),
              onPressed: () {
                cart.addItems(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} was added to Cart'),
                  duration: Duration(milliseconds: 1600),
                  action: SnackBarAction(
                    label: 'Cancel',
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ),
                );
                },
          )
        ),
      ),
    );
  }
}
