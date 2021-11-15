import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions{
  Favorites,
  All,
}


class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          title: Text('My Shop'),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selectedvalue) {
                  setState(() {
                    if (selectedvalue == FilterOptions.Favorites) {
                      _showOnlyFavorites = true;
                    }
                    else {
                      _showOnlyFavorites = false;
                    }
                  });
                },
                icon: Icon(Icons.more_vert),
                itemBuilder: (_) =>
                [
                  PopupMenuItem(child: Text('Only Favorites'),
                    value: FilterOptions.Favorites,),
                  PopupMenuItem(child: Text('All'), value: FilterOptions.All,),
                ]
            ),
            Consumer<Cart>(builder: (_, cart, ch) =>
                Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme
                      .of(context)
                      .accentColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 600,
                          child: Image.asset(
                            'images/wifi.png', fit: BoxFit.cover,),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text('Check your connection and try again',
                            style: TextStyle(fontSize: 30, color: Colors.lightBlue),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ],
                  ),
                );
              } else {
                return Consumer<Products>(
                  builder: (ctx, orderData, child) =>
                      SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(children: [
                          Container(
                            child: Column(children: [
                              Container(
                                  width: double.infinity,
                                  height: 190,
                                  child: Image.asset(
                                    'images/shop2.jpg', fit: BoxFit.cover,)),
                              Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Text('Available products',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.lightBlue),)),
                              ProductsGrid(_showOnlyFavorites),
                            ],
                            ),
                          ),
                        ],
                        ),
                      ),
                );
              }
            }
          },
        ),
        drawer: AppDrawer(),
    );
  }
}

