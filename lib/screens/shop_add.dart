import 'package:apna_s5/models/shop_category.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../screens/shop.dart';
import '../models/shops.dart';
import '../models/city.dart';

class ShopAddScreen extends StatefulWidget {
  static const routeName = '/ShopAddScreen';

  @override
  _ShopAddScreenState createState() => _ShopAddScreenState();
}

class _ShopAddScreenState extends State<ShopAddScreen> {
  List<DropdownMenuItem<int>> listDrop = [];
  final _minimumOrderFocusNode = FocusNode();
  final _maximumOrderFocusNode = FocusNode();
  final _deliveryChargesFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _locationController = TextEditingController();
  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  var _isInit = true;
  var _editedObj = Shop(
    shopId: null,
    shopCategory: '',
    name: '',
    address: '',
    city: '',
    location: '',
    openingTime: '',
    closingTime: '',
    minimumOrder: 0,
    maximumOrder: 0,
    deliveryCharges: 0,
    slug: '',
    shopStatus: '',
  );
  var _initialValues = {
    'shopCategory': '',
    'name': '',
    'address': '',
    'city': 'Select City',
    'location': '',
    'openingTime': '',
    'closingTime': '',
    'minimumOrder': null,
    'maximumOrder': null,
    'deliveryCharges': 0.0,
    'slug': '',
  };
  String pageTitle = 'Add Shop';
  bool _isLoading = false;
  bool _isLocationLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final passedData =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      if (passedData['slug'] != null) {
        pageTitle = 'Edit Shop';
        _editedObj = Shops.getShop(passedData['slug']);
        _initialValues = {
          'shopCategory': _editedObj.shopCategory,
          'name': _editedObj.name,
          'address': _editedObj.address,
          'city': _editedObj.city,
          'location': _editedObj.location,
          'openingTime': _editedObj.openingTime,
          'closingTime': _editedObj.closingTime,
          'minimumOrder': _editedObj.minimumOrder.toString(),
          'maximumOrder': _editedObj.maximumOrder.toString(),
          'deliveryCharges': _editedObj.deliveryCharges.toString(),
          'slug': _editedObj.slug,
        };
        _locationController.text = _initialValues['location'];
        _openingTimeController.text = _initialValues['openingTime'];
        _closingTimeController.text = _initialValues['closingTime'];
      } else if (passedData['id'] != null) {
        pageTitle =
            'Add ${ShopCategories.items.firstWhere((item) => item.id == passedData['id']).name}';
        _initialValues['shopCategory'] = passedData['id'];
        _editedObj.shopCategory = passedData['id'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _minimumOrderFocusNode.dispose();
    _maximumOrderFocusNode.dispose();
    _deliveryChargesFocusNode.dispose();
    _addressFocusNode.dispose();
    _locationController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  void _loadData() {
    listDrop = [];
    Cities.items.forEach((item) {
      listDrop.add(DropdownMenuItem(
        child: Text(item.name),
        value: int.parse(item.id),
      ));
    });
  }

  void printShop(Shop shop) {
    // print('Printing SHop');
    // print(shop.shopId);
    // print('shopCategory');
    // print(shop.shopCategory);
    // print('name');
    // print(shop.name);
    // print(shop.address);
    // print(shop.city);
    // print(shop.location);
    // print(shop.openingTime);
    // print(shop.closingTime);
    // print(shop.minimumOrder);
    // print(shop.maximumOrder);
    // print(shop.deliveryCharges);
    // print(shop.slug);
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedObj.shopId == null) {
      // print('add a shop');
      await Shops.addShop(_editedObj);
      // printShop(_editedObj);
      // Shops.addShop();
    } else {
      print('update a shop');
      printShop(_editedObj);
      await Shops.updateShop(_editedObj);
    }
    // print(_editedObj.name);
    // save shop
    await Shops.fetchShops();
    // Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).popAndPushNamed(ShopScreen.routeName);
    setState(() {
      _isLoading = false;
    });
  }

  Future<TimeOfDay> selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: _time);
    // print(picked.toString());
    // var t = TimeOfDay.fromDateTime(picked);

    if (picked != null && picked != _time) {
      // print('Time is picked');
      // setState(() {
      _time = picked;
      // });
    }
    return picked;
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });
    final locData = await Location().getLocation();
    setState(() {
      _isLocationLoading = false;
      _locationController.text =
          locData.latitude.toString() + '_' + locData.longitude.toString();
    });
    // print(locData.latitude);
    // print(locData.longitude);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: _initialValues['name'],
                    decoration: InputDecoration(labelText: 'Shop Name'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_minimumOrderFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter shop name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedObj.name = value;
                    },
                  ),
                  TextFormField(
                    initialValue: _initialValues['minimumOrder'] == null
                        ? _initialValues['minimumOrder']
                        : _initialValues['minimumOrder'].toString(),
                    decoration: InputDecoration(labelText: 'Minimum Order'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _minimumOrderFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_maximumOrderFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter minimum order';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedObj.minimumOrder = double.parse(value);
                    },
                  ),
                  TextFormField(
                    initialValue: _initialValues['maximumOrder'] == null
                        ? _initialValues['maximumOrder']
                        : _initialValues['maximumOrder'].toString(),
                    decoration: InputDecoration(labelText: 'Maximum Order'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    focusNode: _maximumOrderFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_deliveryChargesFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter maximum order';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedObj.maximumOrder = double.parse(value);
                    },
                  ),
                  // TextFormField(
                  //   initialValue: _initialValues['deliveryCharges'] == null
                  //       ? _initialValues['deliveryCharges']
                  //       : _initialValues['deliveryCharges'].toString(),
                  //   decoration: InputDecoration(labelText: 'Delivery Charges'),
                  //   textInputAction: TextInputAction.next,
                  //   keyboardType: TextInputType.number,
                  //   focusNode: _deliveryChargesFocusNode,
                  //   onFieldSubmitted: (_) {
                  //     FocusScope.of(context).requestFocus(_addressFocusNode);
                  //   },
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'Enter delivery';
                  //     }
                  //     return null;
                  //   },
                  //   onSaved: (value) {
                  //     _editedObj.deliveryCharges = double.parse(value);
                  //   },
                  // ),
                  TextFormField(
                    initialValue: _initialValues['address'],
                    decoration: InputDecoration(labelText: 'Address'),
                    keyboardType: TextInputType.text,
                    focusNode: _addressFocusNode,
                    onFieldSubmitted: (_) {
                      // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _editedObj.address = value;
                    },
                  ),
                  DropdownButtonFormField(
                    items: listDrop,
                    hint: Text(_initialValues['city']),
                    onChanged: (value) {
                      // print('Value is: $value');
                      _editedObj.city = Cities.items
                          .firstWhere((item) => item.id == value.toString())
                          .name;
                      setState(() {
                        _initialValues['city'] = _editedObj.city;
                      });
                    },
                    validator: (value) {
                      if (_initialValues['city'] == 'Select City' ||
                          value == null) {
                        return 'Enter city';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // print(Cities.items);
                      // print(value);
                      _editedObj.city = Cities.items
                          .firstWhere((item) => item.id == value.toString())
                          .name;
                      ;
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(labelText: 'Location'),
                          keyboardType: TextInputType.text,
                          controller: _locationController,
                          onFieldSubmitted: (_) {
                            // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              _showErrorDialog('Enter location');
                              return 'Enter location';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedObj.location = value;
                          },
                        ),
                      ),
                      _isLocationLoading == true
                          ? CircularProgressIndicator()
                          : IconButton(
                              icon: Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                              onPressed: _getCurrentLocation,
                            ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: TextFormField(
                          enabled: false,
                          decoration:
                              InputDecoration(labelText: 'Opening Time'),
                          keyboardType: TextInputType.text,
                          controller: _openingTimeController,
                          onFieldSubmitted: (_) {
                            // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              _showErrorDialog('Enter opening time');
                              return 'Enter opening time ';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedObj.openingTime = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.timer,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          picked = await selectTime(context);
                          // print('Picked Time is');
                          // print(picked);
                          if (picked != null) {
                            setState(() {
                              _openingTimeController.text =
                                  picked.hour.toString() +
                                      ':' +
                                      picked.minute.toString();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: TextFormField(
                          enabled: false,
                          decoration:
                              InputDecoration(labelText: 'Closing Time'),
                          keyboardType: TextInputType.text,
                          controller: _closingTimeController,
                          onFieldSubmitted: (_) {
                            // FocusScope.of(context).requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              _showErrorDialog('Enter closing time');
                              return 'Enter closing time';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedObj.closingTime = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.timer,
                          color: Colors.green,
                        ),
                        onPressed: () async {
                          picked = await selectTime(context);
                          // print('Picked Time is');
                          // print(picked);
                          if (picked != null) {
                            setState(() {
                              _closingTimeController.text =
                                  picked.hour.toString() +
                                      ':' +
                                      picked.minute.toString();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _isLoading == true
                ? CircularProgressIndicator()
                : RaisedButton(
                    child: Text('Save'),
                    onPressed: _saveForm,
                  )
          ],
        ),
      ),
    );
  }
}
