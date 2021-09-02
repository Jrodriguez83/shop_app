import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_products_item.dart';
import '../widgets/drawer.dart';

class UserProductsScreen extends StatefulWidget {
  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var productData;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetData(true).then((_){
     productData = Provider.of<ProductsProvider>(context);
     setState(() {
       _isLoading = false;
     });
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit_product');
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: (){
          return productData.fetchAndSetData(true);
        },
              child: Padding(
          padding: EdgeInsets.all(8),
          child: _isLoading?Center(child: CircularProgressIndicator()): ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: ((_, i) => UserProductsItem(
                  productData.items[i].id,
                  productData.items[i].title,
                  productData.items[i].imageUrl,
                )),
          ),
        ),
      ),
    );
  }
}
