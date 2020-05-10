import 'package:flutter/material.dart';

import '../models/shop_products_category.dart';
import '../models/product_category.dart';
import '../screens/product_manage.dart';
import '../screens/product_select.dart';

class CaregorySelectScreen extends StatelessWidget {
  static const routeName = '/CaregorySelectScreen';

  @override
  Widget build(BuildContext context) {
    final passedData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text('Select Category')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: ShopProductsCategories.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            child: GridTile(
              child: Image.network(
                  ProductCategories.items
                      .firstWhere((item) =>
                          item.id ==
                          ShopProductsCategories.items[i].productCategory)
                      .image,
                  fit: BoxFit.cover),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                    ProductCategories.items
                        .firstWhere((item) =>
                            item.id ==
                            ShopProductsCategories.items[i].productCategory)
                        .name,
                    textAlign: TextAlign.center),
              ),
            ),
            onTap: () {
              // print(passedData);
              if (passedData['page'] == 'shop') {
                Navigator.of(context).pushNamed(ProductManageScreen.routeName,
                    arguments: ShopProductsCategories.items[i].id);
              } else if (passedData['page'] == 'product') {
                Navigator.of(context).pushNamed(ProductSelectScreen.routeName,
                    arguments: ShopProductsCategories.items[i].id);
              }
            },
          ),
        ),
      ),
    );
  }
}
