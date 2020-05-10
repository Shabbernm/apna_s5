import 'package:flutter/material.dart';

import '../screens/dashboard.dart';
import '../screens/auth_screen.dart';
import '../screens/shop.dart';
import '../screens/category_select.dart';
import '../screens/product_select.dart';
import '../screens/orders.dart';
import '../models/shop_category.dart';
import '../models/shops.dart';
import '../models/shop_products_category.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Welcome to Apna Bazar!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DashboardScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Manage Shops'),
            onTap: () {
              Navigator.of(context)
                  .popAndPushNamed(ShopScreen.routeName, arguments: 'shop');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              if (ShopCategories.items
                      .firstWhere(
                          (item) => item.id == Shops.items[0].shopCategory)
                      .name ==
                  'Grocery Shop') {
                Navigator.of(context).popAndPushNamed(
                    CaregorySelectScreen.routeName,
                    arguments: {'page': 'product'});
              } else {
                Navigator.of(context).popAndPushNamed(
                    ProductSelectScreen.routeName,
                    arguments: ShopProductsCategories.items[0].id);
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).popAndPushNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payments'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(PaymentScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              // Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
