import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../models/shops.dart';
import '../models/shop_category.dart';
import '../models/shop_products_category.dart';
import '../models/shop_product.dart';
import '../models/product_category.dart';
import '../screens/shop_category.dart';
import '../screens/category_select.dart';
import '../screens/product_manage.dart';
import './category_manage.dart';
import './shop_add.dart';

class ShopScreen extends StatelessWidget {
  static const routeName = '/ShopScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Shop Details')),
      body: Shops.items.length > 0
          ? ListView(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      Text(Shops.items[0].name),
                      Text(ShopCategories.items
                          .firstWhere(
                              (item) => item.id == Shops.items[0].shopCategory)
                          .name),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Opening: ${Shops.items[0].openingTime}'),
                          Text('Closing: ${Shops.items[0].closingTime}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Min: ${Shops.items[0].minimumOrder}'),
                          Text('Max: ${Shops.items[0].maximumOrder}'),
                        ],
                      ),
                      // Text(
                      //     'Delivery charges: ${Shops.items[0].deliveryCharges}'),
                      RaisedButton(
                        child: Text('Edit'),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ShopAddScreen.routeName, arguments: {
                            'slug': Shops.items[0].slug,
                          });
                          // Navigator.of(context).pushNamed(ShopDetailsScreen.routeName);
                        },
                      )
                    ],
                  ),
                ),
                if(ShopCategories.items
                            .firstWhere((item) =>
                                item.id == Shops.items[0].shopCategory)
                            .name ==
                        'Grocery Shop'
                    ) Card(
                        child: Column(
                          children: <Widget>[
                            Text(
                                'Total number of Product Categories are ${ShopProductsCategories.items.length}'),
                            RaisedButton(
                              child: Text('Manage Categories'),
                              onPressed: () {
                                // print('ShopProductsCategories.items.length');
                                // print(ShopProductsCategories.items.length);
                                Navigator.of(context)
                                    .pushNamed(CategoryManageScreen.routeName);
                              },
                            ),
                          ],
                        ),
                      ),
                Card(
                  child: Column(
                    children: <Widget>[
                      Text('There are ${ShopProducts.items.length} products'),
                      RaisedButton(
                        child: Text('Manage Products'),
                        onPressed: () {
                          if (ShopCategories.items
                                  .firstWhere((item) =>
                                      item.id == Shops.items[0].shopCategory)
                                  .name ==
                              'Grocery Shop') {
                            Navigator.of(context).pushNamed(
                                CaregorySelectScreen.routeName,
                                arguments: {'page': 'shop'});
                          } else {
                            // print(ShopProductsCategories.items.length);
                            Navigator.of(context).pushNamed(
                                ProductManageScreen.routeName,
                                arguments: ShopProductsCategories.items[0].id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Add a shop first'),
                RaisedButton(
                  child: Text('Add a Shop'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ShopCategoryScreen.routeName);
                  },
                ),
              ],
            ),
    );
  }
}
