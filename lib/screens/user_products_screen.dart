import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext cont) async {
    await Provider.of<Products>(cont, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('My products'),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
              icon: const Icon(Icons.add_box_sharp, color: Colors.lightBlue, size: 30,),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
            return Center(child: Text(
                'An error occurred!\nCheck your connection and try again',
                textAlign: TextAlign.center,
            ),
            );
          } else {
            return Consumer<Products>(
                builder: (ctx, productsData, _) => Column(children: [
                  Container(
                      width: double.infinity,
                      height: 190,
                      child: Image.asset('images/products2.jpg', fit: BoxFit.cover,)
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                       child: Text('My Products', style: TextStyle(fontSize: 30, color: Colors.blue),)),
                  RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                        child: Container(
                          height: 447,
                          padding: EdgeInsets.all(8),
                          child: productsData.items.length == 0 ?
                          Center(
                            child: Text(
                              'You have not added any products yet',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.lightBlue),
                              textAlign: TextAlign.center,),
                          )
                              : ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) => Column(children: [
                                    UserProductItem(productsData.items[i].title, productsData.items[i].imageUrl, productsData.items[i].id),
                                    Divider(),
                                  ],
                                  )
                          ),
                        ),
                  ),
                ],
              ),
            );
            }
          }
        }
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProductScreen.routeName);
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, size: 30, color: Colors.lightBlue,),
      ),
    );
  }
}