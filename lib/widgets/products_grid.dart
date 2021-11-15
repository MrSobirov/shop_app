import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  Future<void> refreshProductsScreen(BuildContext cont) async {
    await Provider.of<Products>(cont, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favorites : productsData.items;
    return RefreshIndicator(
        onRefresh: () => refreshProductsScreen(context),
        child: Container(
          height: 510,
          padding: EdgeInsets.all(8),
          child: GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                //create: (c) => products[i],
                value: products[i],
                child: ProductItem(
                  /*products[i].id,
                   products[i].title,
                   products[i].imageUrl*/),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3/2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              )
          ),
        ),
    );
  }
}
