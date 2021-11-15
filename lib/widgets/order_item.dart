import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/orders.dart';

class Order_Item extends StatefulWidget {
  final OrderItem order;

  Order_Item(this.order);

  @override
  _Order_ItemState createState() => _Order_ItemState();
}

class _Order_ItemState extends State<Order_Item> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return Dismissible(
      key: ValueKey(widget.order.id),
      background: Container(
          color: Colors.redAccent,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15),
          margin: EdgeInsets.fromLTRB(20, 8, 0, 8),
        ),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you really want to delete this order from history?'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('YES')
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('NO')
                ),
              ],
            ),
        );
      },
      onDismissed: (direction) async {
        try {
          await Provider.of<Orders>(context, listen: false).removeOrder(
              widget.order.id);
        } catch (error){
          scaffold.showSnackBar(SnackBar(
            content: Text('Deleting failed!', textAlign: TextAlign.center,),
          )
          );
        }
    },
      child:AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 88,
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              ListTile(
                title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a').format(widget.order.dateTime)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: (){
                  setState(() {
                    _expanded = !_expanded;
                  }
                  );
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded ? min(widget.order.products.length * 20.0 + 10, 100) : 0,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: widget.order.products.map((prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prod.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text(
                      '${prod.quantity}x \$${prod.price}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),)
                  ],
                )).toList(),
              ),
            )
            ],
          ),
        ),
      ),
    );
  }
}
