import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditUserProductScreen extends StatefulWidget {
  @override
  _EditUserProductScreenState createState() => _EditUserProductScreenState();
}

class _EditUserProductScreenState extends State<EditUserProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrl = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _isInit = true;
  var product = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var newProd = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        newProd = false;
        product = Provider.of<ProductsProvider>(context).findById(id);
        _imageUrl.text = product.imageUrl;
      }
    }
    _isInit = false;
  }

  void _updateUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrl.dispose();
    // _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(_updateUrl);
    super.dispose();
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
    if (newProd) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(product);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: ((ctx) => AlertDialog(
                  content: Text(error.toString()),
                  title: Text('Error'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    )
                  ],
                )));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(product, product.id);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: ((ctx) => AlertDialog(
                  content: Text(error.toString()),
                  title: Text('Error'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    )
                  ],
                )));
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title.isEmpty ? 'Add product' : 'Edit PRoduct'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: product.title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        product = Product(
                            id: product.id,
                            title: value,
                            description: product.description,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title must not be empty';
                        }

                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: product.price.toString(),
                      focusNode: _priceFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        product = Product(
                            id: product.id,
                            title: product.title,
                            description: product.description,
                            price: double.parse(value),
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Price must not be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Price must be higher than 0';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      initialValue: product.description,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      textInputAction: TextInputAction.newline,
                      onSaved: (value) {
                        product = Product(
                            id: product.id,
                            title: product.title,
                            description: value,
                            price: product.price,
                            imageUrl: product.imageUrl,
                            isFavorite: product.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Description must not be empty';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          height: 100,
                          width: 100,
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          child: _imageUrl.text.isEmpty
                              ? Text('Enter URL')
                              : Image.network(
                                  _imageUrl.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                            child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Image URL',
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrl,
                          focusNode: _imageUrlFocus,
                          onSaved: (value) {
                            product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                imageUrl: value,
                                isFavorite: product.isFavorite);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a valid URL';
                            }
                            return null;
                          },
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
