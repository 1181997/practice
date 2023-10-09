import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:practice/api/add_data.dart';
import 'package:practice/api/posts_model.dart';
import 'package:practice/first.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import '../login_page.dart';
import '../notificationservice/local_notification_service.dart';
import '../services/logout.dart';
import 'api_service.dart';




class ProductList extends StatefulWidget {
  final AuthMethod authMethod;
  const ProductList({super.key,required this.authMethod});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();


  @override
  void initState() {
    super.initState();
    myBanner.load();

    FacebookAudienceNetwork.init(
      testingId: "549167759165615_549192715829786"
    );


    AuthMethod _authMethod = widget.authMethod;
    // 1. This method call when app in terminated state and you get a notification
        FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);

        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  BannerAd myBanner = BannerAd(
    adUnitId: "ca-app-pub-3940256099942544/6300978111", // Use test ID for testing
    size: AdSize.banner,
    request: AdRequest(),
    listener:  BannerAdListener(
      onAdFailedToLoad: (ad, error) {
        print('Ad failed to load: $error');
        // Retry loading the ad after a delay
        Future.delayed(Duration(seconds: 30), () {
        });
      },
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product Api"),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {

               Navigator.pop(context); // Close the drawer

              },
            ),
            ListTile(
              leading: Icon(Icons.car_crash),
              title: Text('Crash App'),
              onTap: () {
                throw Exception();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async{
                if(widget.authMethod == AuthMethod.google) {

                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>first()));

              }else if(widget.authMethod == AuthMethod.facebook){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>logout()));
                }
    }
            ),
          ],
        ),
      ),

      body: FutureBuilder(future: getPost(),builder: (context, AsyncSnapshot snapshot){

            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              List<Product> product = snapshot.data;

              return ListView.builder(itemCount: product.length,
                itemBuilder: (BuildContext context,int index) {
                return Card(
                  child: Padding(padding: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: Image.network(product[index].thumbnail,
                        width: 100,),
                      title: Text(product[index].title),
                      subtitle: Row(
                        children: [
                          Expanded(
                              child: Text(product[index].description)),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(product[index].price.toString()),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },);
            }
          }),



      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //postData();
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddData()));
        },
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: Container(
        child: AdWidget(ad: myBanner),
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      ),
    );
  }


}

