import 'package:flutter/material.dart';
import '../models/product_subcategory.dart';
import '../models/product.dart';
import '../models/shop_product.dart';
import '../models/shop_category.dart';
import '../models/shops.dart';
import '../screens/shop.dart';

class ProductManageScreen extends StatefulWidget {
  static const routeName = '/ProductManageScreen';

  @override
  _ProductManageScreenState createState() => _ProductManageScreenState();
}

class _ProductManageScreenState extends State<ProductManageScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  double price;

  void _saveData(Product product, String shopProductCategoryId) async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    print('insert this product.');
    await ShopProducts.insertShopProduct(
      product,
      shopProductCategoryId,
      price,
    );
    print('Products.items.length: ${Products.items.length}');
    Products.items.firstWhere((prod) => prod.id == product.id).available = true;

    // await ShopProducts.fetchShopProducts();
    Navigator.of(context).pop(true);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    if (ShopCategories.items
            .firstWhere((item) => item.id == Shops.items[0].shopCategory)
            .name ==
        'Grocery Shop') {
      Navigator.of(context).pop();
    }

    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(ShopScreen.routeName);
  }

  List<Product> getProductsBySubcategory(String subcategoryId) {
    List<Product> localList = [];
    print('Products.items.length: ${Products.items.length}');
    Products.items.forEach((product) {
      if (product.productSubcategory == subcategoryId) {
        localList.add(product);
      }
    });
    return localList;
  }

  Future<bool> _confirmDelete(BuildContext context, String productId) {
    print('im in confirm');
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Are you sure, you want to delete this product?'),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Text("NO"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: GestureDetector(
                        onTap: () async {
                          print('Delete this product.');
                          await ShopProducts.deleteShopProduct(productId);
                          Navigator.of(context).pop(true);
                        },
                        child: Text("YES"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _confirmInsert(
      BuildContext context, Product product, String shopProductCategoryId) {
    print('im in confirm');
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Wanna add this product!'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter price';
                  }
                  return null;
                },
                onSaved: (value) {
                  price = double.parse(value);
                },
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: RaisedButton(
                        child: Text("Add"),
                        onPressed: () =>
                            _saveData(product, shopProductCategoryId),
                      ),
                      // GestureDetector(
                      //   onTap: () => _saveData(product, shopProductCategoryId),
                      //   child: Text("Add"),
                      // ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var shopProductCategoryId =
        ModalRoute.of(context).settings.arguments as String;
    // print('shopProductCategoryId');
    // print(shopProductCategoryId);
    var subcategoriesList =
        ProductSubcategories.getProductSubcategoriesByShopProductCategoryId(
            shopProductCategoryId);
    print(subcategoriesList);
    return DefaultTabController(
      length: subcategoriesList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Products'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null,
            )
          ],
          bottom: TabBar(
            tabs: subcategoriesList.map((subcategory) {
              return Tab(
                child: Text(subcategory.name),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: subcategoriesList.map((subcategory) {
            return ListView(
              children: getProductsBySubcategory(subcategory.id).map((product) {
                return Card(
                  child: ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.name),
                    trailing: Checkbox(
                        value: product.available,
                        onChanged: (value) {
                          setState(() {
                            product.available = value;
                          });
                        }),
                    onTap: () => product.available == false
                        ? _confirmInsert(
                            context, product, shopProductCategoryId)
                        : _confirmDelete(context, product.id),
                    // () {
                    //   setState(() {
                    //     product.available = !product.available;
                    //   });
                    // },
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}
