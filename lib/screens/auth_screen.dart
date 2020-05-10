import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exceptions/http_exception.dart';
import '../exceptions/success_exception.dart';
// import '../models/auth.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/AuthScreen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 177, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'ApnaBazar',
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.title.color,
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success Message!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _switchAuthMode();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext ctx) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        // await Auth.login(_authData['email'],
        //   _authData['password'], ctx);
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        // await Auth.signup(
        //   _authData['email'],
        //   _authData['password']);
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('email already exists')) {
        errorMessage = 'User with this email already exists.';
      } else if (error.toString().contains('Enter a valid email address.')) {
        errorMessage = 'Enter a valid email address.';
      } else if (error.toString().contains('at least 8 characters')) {
        errorMessage = 'Ensure password field has at least 8 characters.';
      } else if (error
          .toString()
          .contains('Unable to authenticate with provided credentials')) {
        errorMessage = 'Unable to authenticate with provided credentials';
      }
      _showErrorDialog(errorMessage);
    } on SuccessException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('Created Sucessfully')) {
        errorMessage = 'Account Created Sucessfully, Now try to login!';
      }
      _showSuccessDialog(errorMessage);
    } catch (error) {
      print('error');
      print(error);
      var errorMessage = 'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  // validator: (value) {
                  //   if (value.isEmpty || !value.contains('@')){
                  //     return 'Invalid email!';
                  //   }
                  // },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                  },
                  // validator: (value) {
                  //   if (value.isEmpty || value.length < 5 ){
                  //     return 'Password is too short!';
                  //   }
                  // },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    // validator: _authMode == AuthMode.Signup ? (value) {
                    //   if (value.isEmpty || value.length < 5 ){
                    //     return 'Password is too short!';
                    //   }
                    // }: null,
                  ),
                SizedBox(height: 20),
                if (_isLoading == true)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: () => _submit(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
