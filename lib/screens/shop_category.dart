import 'package:flutter/material.dart';

import '../models/shop_category.dart';
import '../screens/shop_add.dart';

class ShopCategoryScreen extends StatelessWidget {
  static const routeName = '/ShopCategoryScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Shop Type')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: ShopCategories.items.length,
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
              child: Image.network(ShopCategories.items[i].image,
                  fit: BoxFit.cover),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(ShopCategories.items[i].name,
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ShopAddScreen.routeName, arguments: {'id': ShopCategories.items[i].id});
          },
        ),
      ),
    );
  }
}
