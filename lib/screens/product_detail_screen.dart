import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as List<Object>;
    final product = Provider.of<ProductsProvider>(context)
        .items
        .firstWhere((products) => products.id == (id[0] as String));

    final productData = id[1] as Product;

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        //   actions: <Widget>[
        //     IconButton(
        //         icon: Icon(productData.isFavorite
        //             ? Icons.favorite
        //             : Icons.favorite_border),
        //         onPressed: () {
        //           setState(() {
        //             productData.toggleFavoriteStatus(
        //                 (id[2] as String), (id[3] as String));
        //           });
        //         }),
        //     AddToCart(product: product)
        //   ],
        // ),
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              color: Colors.purple.withOpacity(0.5),
              child: Text(product.title),
            ),
            background: Hero(
              tag: product.id,
              child: Image.network(product.imageUrl),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(productData.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                    color: Colors.orange,
                onPressed: () {
                  setState(() {
                    productData.toggleFavoriteStatus(
                        (id[2] as String), (id[3] as String));
                  });
                }),
            AddToCart(product: product)
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              color: Colors.grey,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Text(
                '\$${product.price}',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Container(
              child: Text(
                product.description,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 800,
            ),
          ]),
        )
      ],
    ));
  }
}

class AddToCart extends StatelessWidget {
  const AddToCart({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.add_shopping_cart),
        color: Colors.orange,
        onPressed: () {
          Provider.of<Cart>(context)
              .addItem(product.id, product.price, product.title);

          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('${product.title} added to cart'),
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                Provider.of<Cart>(context).removeSingleItem(product.id);
              },
            ),
          ));
        });
  }
}
