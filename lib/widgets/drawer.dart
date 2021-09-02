import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          AppBar(
            title: Text('Shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.credit_card,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Orders'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed('/orders_screen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Products'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed('/user_products'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('LogOut'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context).logOut();
            },
          )
        ],
      ),
    );
  }
}
