import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_user_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './helper/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          builder: ((ctx, authData, previousPP) => ProductsProvider(
                authData.token,
                authData.userId,
                previousPP == null ? [] : previousPP.items,
              )),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: ((ctx, authData, prevOrder) => Orders(
                authData.token,
                prevOrder == null ? [] : prevOrder.order,
                authData.userId,
              )),
        )
      ],
      child: Consumer<Auth>(
        builder: ((ctx, authData, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  }
                ),
                primarySwatch: Colors.purple,
                accentColor: Colors.orange,
                fontFamily: 'Lato',
              ),
              home: authData.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: authData.tryAutoLogin(),
                      builder: (ctx, authSnapShot) =>
                          authSnapShot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                '/product-detail': (_) => ProductDetailScreen(),
                '/cart_screen': (_) => CartScreen(),
                '/orders_screen': (_) => OrdersScreen(),
                '/user_products': (_) => UserProductsScreen(),
                '/edit_product': (_) => EditUserProductScreen(),
              },
            )),
      ),
    );
  }
}
