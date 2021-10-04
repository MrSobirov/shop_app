import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedproduct = Product(
      id: null,
      title: '',
      description: '',
      price: 0,
      imageUrl: '',
  );
  var _initValues = {
    'title' : '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productID = ModalRoute.of(context).settings.arguments as String;
      if(productID != null) {
        _editedproduct = Provider.of<Products>(context, listen: false).findbyID(productID);
        _initValues = {
          'title': _editedproduct.title,
          'description': _editedproduct.description,
          'price': _editedproduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedproduct.imageUrl;
        _isInit = false;
      }
    }
    super.didChangeDependencies();
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

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus) {
      if((!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') && !_imageUrlController.text.endsWith('.jpg') && !_imageUrlController.text.endsWith('.jpeg')))
      {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedproduct.id != null){
      await Provider.of<Products>(context, listen: false).updateProduct(_editedproduct.id, _editedproduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedproduct);
      } catch(error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okay')
                ),
              ],
            )
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isInit ? Text('Add new product') : Text('Edit existing product'),
        actions: [
          _isInit ? IconButton(icon: Icon(Icons.save), onPressed: _saveform, color: Colors.lightBlue,)
              : IconButton(icon: Icon(Icons.done_outline_rounded), onPressed: _saveform, color: Colors.lightBlue,),
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 370,
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_){
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if(value.isEmpty)
                          {
                            return 'Please enter a title';
                          }
                        return null;
                      },
                      onSaved: (value) => _editedproduct = Product(
                          id: _editedproduct.id,
                          isFavorite: _editedproduct.isFavorite,
                          title: value,
                          description: _editedproduct.description,
                          price: _editedproduct.price,
                          imageUrl: _editedproduct.imageUrl,
                      ),
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_){
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if(value.isEmpty)
                          {
                            return 'Please enter a price';
                          }
                        if(double.tryParse(value) == null)
                          {
                            return 'Please enter a valid number.';
                          }
                        if(double.parse(value) <= 0)
                          {
                            return 'Please enter a number greater than zero.';
                          }
                        return null;
                      },
                      onSaved: (value) => _editedproduct = Product(
                          id: _editedproduct.id,
                          isFavorite: _editedproduct.isFavorite,
                          title: _editedproduct.title,
                          description: _editedproduct.description,
                          price: double.parse(value),
                          imageUrl: _editedproduct.imageUrl),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if(value.isEmpty)
                          {
                            return 'Please enter description.';
                          }
                        if(value.length < 15)
                          {
                            return 'Should be at least 10 characters long.';
                          }
                        return null;
                      },
                      onSaved: (value) => _editedproduct = Product(
                          id: _editedproduct.id,
                          isFavorite: _editedproduct.isFavorite,
                          title: _editedproduct.title,
                          description: value,
                          price: _editedproduct.price,
                          imageUrl: _editedproduct.imageUrl),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey
                            )
                          ),
                          child: _imageUrlController.text.isEmpty ?
                          Text('Enter URL'):
                          FittedBox(
                             child:  Image.network(_imageUrlController.text, fit: BoxFit.cover,),),
                          ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if(value.isEmpty)
                                {
                                  return 'Please enter a image URL';
                                }
                              if(!value.startsWith('http') && !value.startsWith('https'))
                                {
                                  return 'Please enter a valid URL';
                                }
                              if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg'))
                                {
                                  return 'Please enter a valid image URL';
                                }
                              return null;
                            },
                            onSaved: (value) => _editedproduct = Product(
                                id: _editedproduct.id,
                                isFavorite: _editedproduct.isFavorite,
                                title: _editedproduct.title,
                                description: _editedproduct.description,
                                price: _editedproduct.price,
                                imageUrl: value),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            FlatButton(
                onPressed: _saveform,
                child: Text(
                  _isInit ? 'Add product' : 'Save product',
                  style: TextStyle(fontSize: 18,),
                  ),
                color: Colors.cyan,
            )
          ],
        ),
      ),
    );
  }
}
