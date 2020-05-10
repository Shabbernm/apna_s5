
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../models/auth.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer.dart';
import '../models/shop_product.dart';
import '../models/shops.dart';
import '../providers/conf_data.dart';
import '../providers/orders.dart';
import '../screens/orders.dart';
import '../screens/splash.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (onceDataIsFetched == false) {
      confContext = context;
      Provider.of<Orders>(context).fetchDataFromServer();
      // Provider.of<OrderShopProducts>(context).fetchDataFromServer();
    }
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: onceDataIsFetched == false
          ? FutureBuilder(
              future: Provider.of<Auth>(context).fetchOnce(),
              builder: (ctx, authResultSnapshot) =>
                  authResultSnapshot.connectionState == ConnectionState.waiting
                      ? SplashScreen('Fetching latest data from server')
                      : DashboardWidget(),
            )
          : DashboardWidget(),
    );
  }
}

class DashboardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedOrders = Provider.of<Orders>(context).items;
    
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Dasboard')),
      body: ListView(
        children: <Widget>[
          Text(Shops.items[0].name),
          Text('You have ${ShopProducts.items.length} Products'),
          Text('About Orders'),
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(OrderScreen.routeName),
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    loadedOrders.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          // Column(children: <Widget>[],),
        ],
      ),
    );
  }
}
