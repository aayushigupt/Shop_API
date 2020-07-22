import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Provider/Product.dart';
import 'package:shop/models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();

  final _imageUrlController = new TextEditingController();

  final _imageUrlFocusNode = FocusNode();
  //to get direct access to form and we introduce global
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageurl': '',
  };
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith("http") ||
          !_imageUrlController.text.startsWith("https")) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
    if (_editedProduct != null) {
      Provider.of<Products>(context).updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context).addProduct(_editedProduct);
    }
    

    Navigator.of(context).pop();
  }

  void didChangeDependencies() {
    
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product"), actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveForm,
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                   initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                      isFavourite: _editedProduct.isFavourite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a valid title';
                    }
                    return null;
                  }),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value),
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a valid Price!!';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price greater then 0';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a valid description';
                  }
                  if (value.length < 10) {
                    return 'At least 10 characters required';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter an image URL")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Image URL",
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      //because it takes a string
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: value,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid url';
                        }
                        if (!value.startsWith("http") ||
                            !value.startsWith("https")) {
                          return 'Please enter a valid url';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
