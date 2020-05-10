import 'package:flutter/material.dart';

import '../models/shop_product.dart';
import '../models/product.dart';
import '../models/product_brand.dart';

class ProductEditScreen extends StatefulWidget {
  static const routeName = '/ProductEditScreen';
  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  bool _isLoading = false;
  var _initialValues = {
    'price': 0.0,
  };
  ShopProduct shopProduct;
  final _formKey = GlobalKey<FormState>();

  void _saveData() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    var updatedObj = await ShopProducts.updateShopProduct(
        shopProduct, _initialValues['price']);
    ShopProducts.items.remove(shopProduct);
    ShopProducts.items.add(updatedObj);
    setState(() {
      _isLoading = false;
    });
    // await ShopProducts.fetchShopProducts();
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    final passedId = ModalRoute.of(context).settings.arguments as String;
    shopProduct =
        ShopProducts.items.firstWhere((shopProd) => shopProd.id == passedId);
    _initialValues = {
      'price': shopProduct.price,
    };
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                    height: 200,
                    child: Image.network(Products.items
                        .firstWhere((prod) => prod.id == shopProduct.product)
                        .image)),
                Text(ProductBrands.items
                    .firstWhere((brand) =>
                        brand.id ==
                        Products.items
                            .firstWhere(
                                (prod) => prod.id == shopProduct.product)
                            .productBrand)
                    .name),
                Text(Products.items
                    .firstWhere((prod) => prod.id == shopProduct.product)
                    .name),
                Text(Products.items
                    .firstWhere((prod) => prod.id == shopProduct.product)
                    .description),
                TextFormField(
                  initialValue: _initialValues['price'].toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter shop name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _initialValues['price'] = double.parse(value);
                  },
                ),
              ],
            ),
          )),
          _isLoading==true?
            CircularProgressIndicator()
          :
            RaisedButton(
              child: Text('Save'),
              onPressed: _saveData,
            ),
        ],
      ),
    );
  }
}
