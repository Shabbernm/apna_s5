import 'package:flutter/material.dart';

import '../models/shop_product.dart';
import '../models/product_subcategory.dart';
import '../models/product.dart';
import '../screens/product_edit.dart';

class ProductSelectScreen extends StatefulWidget {
  static const routeName = '/ProductSelectScreen';

  @override
  _ProductSelectScreenState createState() => _ProductSelectScreenState();
}

class _ProductSelectScreenState extends State<ProductSelectScreen> {
  List<ShopProduct> getShopProductsBySubcategory(String subcategoryId) {
    List<ShopProduct> localList = [];

    ShopProducts.items.forEach((shopProduct) {
      if (Products.items
              .firstWhere((prod) => prod.id == shopProduct.product)
              .productSubcategory ==
          subcategoryId) {
        localList.add(shopProduct);
      }
    });
    return localList;
  }

  @override
  Widget build(BuildContext context) {
    var shopProductCategoryId =
        ModalRoute.of(context).settings.arguments as String;
    List<ProductSubcategory> subcategoriesList = [];
    List<ProductSubcategory> subcategoriesList2 =
        ProductSubcategories.getProductSubcategoriesByShopProductCategoryId(
            shopProductCategoryId);
    subcategoriesList2.forEach((subcategory) {
      if (getShopProductsBySubcategory(subcategory.id).length > 0) {
        subcategoriesList.add(subcategory);
      }
    });
    return DefaultTabController(
      length: subcategoriesList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Product'),
          bottom: TabBar(
              tabs: subcategoriesList.map((subcategory) {
            return Tab(
              child: Text(subcategory.name),
            );
          }).toList()),
        ),
        body: TabBarView(
            children: subcategoriesList.map((subcategory) {
          return ListView(
            children:
                getShopProductsBySubcategory(subcategory.id).map((shopProduct) {
              return Card(
                child: ListTile(
                  leading: Image.network(Products.items
                      .firstWhere((prod) => prod.id == shopProduct.product)
                      .image),
                  title: Text(Products.items
                      .firstWhere((prod) => prod.id == shopProduct.product)
                      .name),
                  subtitle: Text(shopProduct.price.toString()),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.of(context).pushNamed(ProductEditScreen.routeName,
                        arguments: shopProduct.id);
                  },
                ),
              );
            }).toList(),
          );
        }).toList()),
      ),
    );
  }
}
