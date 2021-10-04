import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(6, 2, 0, 2),
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 30,),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.edit), color: Colors.amberAccent, onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
                }),
                IconButton(icon: Icon(Icons.delete), color: Colors.redAccent, onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to delete this product from shop permanently?'),
                        actions: [
                          FlatButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop(false);
                                try {
                                  await Provider.of<Products>(context, listen: false)
                                      .deleteProduct(id);
                                } catch(error) {
                                  scaffold.showSnackBar(SnackBar(
                                    content: Text('Deleting failed!', textAlign: TextAlign.center,),
                                  )
                                  );
                                }
                              },
                              child: Text('YES'),
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              child: Text('NO')
                          ),
                        ],
                      )
                  );
                  },
                ),
              ],
            ),
        ),
    );
  }
}
