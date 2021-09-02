import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductsItem(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: MediaQuery.of(context).size.width * 0.24,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/edit_product', arguments: id);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: ((ctx) => AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text('Do you want to remove this Item?'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Provider.of<ProductsProvider>(context)
                                          .removeProduct(id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No')),
                              ],
                            )));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
