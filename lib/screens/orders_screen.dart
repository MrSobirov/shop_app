import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.blueGrey[400],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                  child: Text('An error occurred!\nCheck your connection and try again',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => Column(children: [
                  Container(
                    width: double.infinity,
                    height: 190,
                     child: Image.asset('images/orders2.jpg', fit: BoxFit.cover,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('Completed orders', style: TextStyle(fontSize: 30, color: Colors.grey),),
                  ),
                  Container(
                    height: 500,
                      child: orderData.orders.length == 0 ?
                      Center(child: Text(
                        'You have not ordered anything yet',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),)
                          : ListView.builder(
                        itemCount: orderData.orders.length,
                         itemBuilder: (ctx, i) => Order_Item(orderData.orders[i])),
                  ),
               ],
              ),
            );
            }
          }
        },
      ),
    );
  }
}
