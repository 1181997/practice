import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:practice/api/api_service.dart';


class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product Api"),
      ),
      drawer: Drawer(
        // Your drawer code here
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              postData(titleController.text, priceController.text);
            },
            child: Text('Post Data'),
          ),

        ],
      ),
    );
  }
}


Future<void> postData(String title, String price) async {
  final base = "https://dummyjson.com";
  final url = Uri.parse("$base/products/add");
  final data = {
    'title': title,
    'price': price,
  };

  final response = await http.post(url, body: data);

  try {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print(jsonData);
      print("Data is Uploaded Successfully....");

      getPost();

      // You can also refresh the product list here by calling getPost() again.
    } else {
      print("Error During Posting Data");
    }
    dispose();
  } catch (e) {
    print(e.toString());
  }


}

@override
void dispose() {
  // Clean up the controllers when the widget is disposed
  var titleController;
  titleController.dispose();
  var priceController;
  priceController.dispose();
}
