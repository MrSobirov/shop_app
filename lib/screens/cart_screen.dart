import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: Color.fromRGBO(26, 100, 127, 0.7),
        actions: [
          FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Clearing cart'),
                    content: Text('Do you really want to empty the cart fully?'),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            cart.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('YES')
                      ),
                      FlatButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text('NO')
                      ),
                    ],
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.clear, size: 35, color: Colors.redAccent,),
                  Text('Empty Cart', style: TextStyle(fontSize: 13, color: Colors.amberAccent),),
                ],
              )
          )
        ],
      ),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: 190,
              child: Image.asset('images/cart.png', fit: BoxFit.cover,)
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Chip(label: FittedBox(
                    child: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ]
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                  cart.items.values.toList()[i].title,
                  cart.items.keys.toList()[i],
                  cart.items.values.toList()[i].id,
                  cart.items.values.toList()[i].quantity,
                  cart.items.values.toList()[i].price)
              )
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({Key key, @required this.cart}) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount<=0 || _isLoading) ? null : () async {
          setState(() {
            _isLoading = true;
          });
          try {
            await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(), widget.cart.totalAmount);
          } catch(error) {
            print(error);
            await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text('Something went wrong!'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay')
                    ),
                  ],
                )
            );
          }
          widget.cart.clear();
          setState(() {
            _isLoading = false;
          });
      },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}

