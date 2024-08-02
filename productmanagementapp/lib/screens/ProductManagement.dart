import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _qrCodeController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _qrCodeController,
                  decoration: InputDecoration(labelText: 'QR Code'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter QR Code';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _scanQRCode,
                  child: Text('Scan QR Code'),
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter category';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: 'Brand'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter brand';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    try {
      // Scan the QR code
      String qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color for the scan button
        'Cancel', // Text for the cancel button
        true, // Show flash icon
        ScanMode.DEFAULT, // Scan mode
      );

      if (!mounted || qrCode == '-1') return; // Handle cancel or invalid scan

      setState(() {
        _qrCodeController.text = qrCode;
      });

      // After scanning the QR code, automatically fill other fields
      _fillOtherFieldsBasedOnQRCode(qrCode);
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
    }
  }

  void _fillOtherFieldsBasedOnQRCode(String qrCode) {
    // You can implement logic here to fill other fields based on the scanned QR code
    // For example, you can make an HTTP request to fetch additional data and fill the fields
    // This depends on how your backend is set up and what data the QR code contains
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/products'),
          body: {
            'qr_code': _qrCodeController.text,
            'category': _categoryController.text,
            'quantity': _quantityController.text,
            'brand': _brandController.text,
            'description': _descriptionController.text,
          },
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added successfully'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add product'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
