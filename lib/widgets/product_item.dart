import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  void _showSnackBar(
      BuildContext context, String itemName, Cart cart, String prodId) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$itemName added to cart'),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          cart.removeSingleItem(prodId);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/product-detail',
            arguments: [product.id, product, auth.token, auth.userId],
          );
        },
        child: GridTile(
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            footer: GridTileBar(
              leading: Consumer<Product>(
                  builder: (context, product, child) => IconButton(
                        icon: Icon(product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          product.toggleFavoriteStatus(auth.token, auth.userId);
                        },
                      )),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  Scaffold.of(context).hideCurrentSnackBar();
                  _showSnackBar(context, product.title, cart, product.id);
                },
              ),
            )),
      ),
    );
  }
}
