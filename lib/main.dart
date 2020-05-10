
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import './providers/orders.dart';
import './providers/auth.dart';
// import './models/auth.dart';
import './models/order_shop.dart';
import './models/order_shop_product.dart';
import './screens/order_detail.dart';
import './screens/auth_screen.dart';
import './screens/dashboard.dart';
import './screens/splash.dart';
import './screens/category_manage.dart';
import './screens/category_select.dart';
import './screens/product_category.dart';
import './screens/product_edit.dart';
import './screens/product_manage.dart';
import './screens/product_select.dart';
import './screens/shop.dart';
import './screens/shop_add.dart';
import './screens/shop_category.dart';
import './screens/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext ctx) {
    var routes = {
      OrderScreen.routeName: (ctx) => OrderScreen(),
      AuthScreen.routeName: (ctx) => AuthScreen(),
      DashboardScreen.routeName: (ctx) => DashboardScreen(),
      ProductCategoryScreen.routeName: (ctx) => ProductCategoryScreen(),
      ShopScreen.routeName: (ctx) => ShopScreen(),
      ShopAddScreen.routeName: (ctx) => ShopAddScreen(),
      CategoryManageScreen.routeName: (ctx) => CategoryManageScreen(),
      ShopCategoryScreen.routeName: (ctx) => ShopCategoryScreen(),
      CaregorySelectScreen.routeName: (ctx) => CaregorySelectScreen(),
      ProductManageScreen.routeName: (ctx) => ProductManageScreen(),
      ProductSelectScreen.routeName: (ctx) => ProductSelectScreen(),
      ProductEditScreen.routeName: (ctx) => ProductEditScreen(),
      OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Orders()),
        // ChangeNotifierProxyProvider<Orders, OrderShops>(),
        // ChangeNotifierProxyProvider<Orders, OrderShops>(
        //   create: (ctx) => OrderShops([]),
        //   update: (ctx, orders, prevOrderShopsObj) => OrderShops(prevOrderShopsObj.items),
        // ),
        // ChangeNotifierProvider.value(value: OrderShops()),
        // ChangeNotifierProvider.value(value: OrderShopProducts()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Apna Bazar',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth
              ? DashboardScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen('Trying auto login')
                          : AuthScreen()),
          routes: routes,
        ),
      ),
    );
  }
}
