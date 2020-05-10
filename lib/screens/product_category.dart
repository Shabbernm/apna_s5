import 'package:flutter/material.dart';

import '../models/product_category.dart';

class ProductCategoryScreen extends StatefulWidget {
  static const routeName = '/ProductCategoryScreen';

  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    final passedData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    List<ProductCategory> productsCategories = [];

    if (passedData['shopSlug'] != null) {
      print('Shop slug is: ' + passedData['shopSlug']);
      productsCategories = [];
      // ProductsCategories.getShopProductCategories(passedData['shopSlug']);
    } else {
      productsCategories = ProductCategories.items;
    }

    var appbar = AppBar(
      title: Text('Products Category'),
      actions: <Widget>[
        if (passedData['toGoPage'] == 'shop' && editing == false)
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                editing = true;
              });
            },
          ),
        if (passedData['toGoPage'] == 'shop' && editing == true)
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                editing = false;
              });
            },
          ),
      ],
    );

    return Scaffold(
      appBar: appbar,
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: ProductCategories.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: Image.network(ProductCategories.items[i].image,
                  fit: BoxFit.cover),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(ProductCategories.items[i].name,
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          onTap: () {
            print('shopSlug');
            print(passedData['shopSlug']);
            if (passedData['toGoPage'] == 'shop') {
              // Navigator.of(context).pushNamed(SelectProductsScreen.routeName,
              //     arguments: productsCategories[i].productCategoryId);
            } else if (passedData['toGoPage'] == 'product') {
              // Navigator.of(context).pushNamed(ManageProductsScreen.routeName,
              //     arguments: productsCategories[i].productCategoryId);
            }
          },
        ),
      ),
    );
  }
}
