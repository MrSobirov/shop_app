import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/edit_profile_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<Auth>(context).userMail;
    String name = Provider.of<Auth>(context).name;
    String country =Provider.of<Auth>(context).country;
    String photo;
    return Drawer(
      child: Column(
            children: [
              AppBar(
                title: Text(_expanded ? 'My profile' : 'Menu'),
                automaticallyImplyLeading: false,
                actions: [
                  if(_expanded) IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        //Navigator.of(context).pushNamed(ProfileScreen.routeName);
                      }),
                  IconButton(
                      icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      })
                ],
              ),
              if(_expanded) Container(
                padding: EdgeInsets.only(bottom: 10, left: 10),
                height: 90,
                width: double.infinity,
                color: Colors.indigo,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 70,
                        height: 85,
                        child: photo == null ?
                        Image.asset('images/nophoto.jpg', fit: BoxFit.cover,)
                            : Image.network('http')
                    ),
                    Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Container(
                             width: 200,
                             child: Text(
                                  'Name: ${name == null ? 'No name' : name}',
                                  style: TextStyle(fontSize: 15),),
                             ),
                            Container(
                              width: 200,
                              child: Text(
                                'Country: ${country == null ? 'Unknown' : country}',
                                 style: TextStyle(fontSize: 15),),
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                'eMail: ${email == null ? 'Undefined' : email}',
                                style: TextStyle(fontSize: 15),),
                            ),
                          ]
                      ),
                  ],
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('Shop'),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Orders'),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.edit_road_rounded),
                title: Text('Manage products'),
                onTap: (){
                  Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app_outlined),
                title: Text('Log out'),
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Exiting the system'),
                      content: Text('Do you want to log out from shop?'),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed('/');
                              Provider.of<Auth>(context, listen: false).logout();
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
              ),
              Divider(),
            ],
          ),
    );
  }
}
