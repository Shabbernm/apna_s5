import 'package:apna_s5/models/product.dart';
import 'package:flutter/material.dart';

import '../models/product_category.dart';
import '../models/shop_products_category.dart';
import '../models/product_subcategory.dart';
import '../models/shops.dart';
import '../screens/shop.dart';

class CategoryManageScreen extends StatefulWidget {
  static const routeName = '/CategoryDetailsScreen';

  @override
  _CategoryManageScreenState createState() => _CategoryManageScreenState();
}

class _CategoryManageScreenState extends State<CategoryManageScreen> {
  bool _isLoading = false;

  void _saveData() async {
    setState(() {
      _isLoading = true;
    });
    List<String> selectedProductCategoriesId =
        ProductCategories.getProductsCategoriesIdList();
    await checkForDelete(
        ShopProductsCategories.items, selectedProductCategoriesId);
    await checkForInsert(
        ShopProductsCategories.items, selectedProductCategoriesId);
    // await ShopProductsCategories.fetchShopProductsCategories();

    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(ShopScreen.routeName);
    setState(() {
      _isLoading = true;
    });
  }

  Future<bool> _confirmDelete(BuildContext context) {
    print('im in confirm');
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text(
                'Unselected categories will delete its corresponding products also!'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Manage Category')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: ProductCategories.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    child: GridTile(
                      child: Image.network(ProductCategories.items[i].image,
                          fit: BoxFit.cover),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(ProductCategories.items[i].name,
                            textAlign: TextAlign.center),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        ProductCategories.items[i].active =
                            !ProductCategories.items[i].active;
                      });
                    },
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Checkbox(
                        value: ProductCategories.items[i].active,
                        onChanged: (state) {
                          setState(() {
                            ProductCategories.items[i].active = state;
                          });
                        }),
                  ),
                ],
              ),
            ),
          )),
          if(_isLoading==true)
            CircularProgressIndicator()
          else
            RaisedButton(
              child: Text('Save'),
              onPressed: _saveData,
            ),
        ],
      ),
    );
  }

  Future<void> checkForDelete(List<ShopProductsCategory> shopProductsCategories,
      List<String> selectedProductCategoriesId) async {
    shopProductsCategories.forEach((shopCategory) async {
      print(shopCategory.productCategory);
      bool founded = false;
      selectedProductCategoriesId.forEach((selectedId) {
        if (selectedId == shopCategory.productCategory) {
          founded = true;
        }
      });
      if (founded == false) {
        // _confirmDelete(context);
        // print(confirm);
        // if (confirm) {
        print('Delete this object: ' + shopCategory.productCategory);
        await ShopProductsCategories.deleteShopProductsCategory(
            shopCategory.productCategory);
      }
      // }
    });
  }

  Future<void> checkForInsert(List<ShopProductsCategory> shopProductsCategories,
      List<String> selectedProductCategoriesId) async {
    selectedProductCategoriesId.forEach((productCategoriesId) async {
      bool founded = false;
      shopProductsCategories.forEach((shopCategory) {
        if (shopCategory.productCategory == productCategoriesId) {
          founded = true;
        }
      });
      if (founded == false) {
        print('Insert this object: ' + productCategoriesId);

        await ShopProductsCategories.insertShopProductsCategory(
            Shops.items[0].shopId, productCategoriesId);

        await ProductSubcategories.fetchProductSubcategories();

        print(
            'ProductSubcategories.items.length: ${ProductSubcategories.items.length}');
        // Products.clearLocalList();
        ProductSubcategories.items.forEach((productSubcategory) async {
          await Products.fetchProducts(productSubcategory.id);
        });
      }
    });
  }
}
