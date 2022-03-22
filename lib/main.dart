import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;

import 'package:csv/csv.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prapp/view_product_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 bool hasData =false;
  bool loaded = false;
  var random = new Random();
  int d =0;

  List<Map<String, dynamic>> _data = [];
  List name = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  List rating = [4, 3, 5, 2, 1];
  List Descrption = [
    "In today's day and age, most people are constantly on the go. They are constantly working, constantly entertaining themselves, and constantly running errands. This can lead to a lot of distractions and a lot of missed opportunities. That's why the average person should have a laptop. A laptop can help keep you on task, allow you to take your work with you, and make it easier to keep up with your social life. With a laptop, you can create documents and presentations on the go, work on them from anywhere, and then email them to your colleagues or bosses. With a laptop, you can keep up with your favorite TV shows and movies while you're on the bus or in the airport. You can take pictures of your travels and upload them to your social media sites with a laptop. And with a laptop, you can video chat with your friends and family while you're in the middle of an adventure. So, whether you're an entrepreneur, a college student, or just a regular person who needs to stay connected, you should have a laptop.",
    "A bike is a vehicle with two wheels and a saddle for the rider. Bikes can be ridden for recreational purposes or as a means of transportation. Bikes are used for leisurely riding around the neighborhood, for exercise, and as a mode of transportation for longer distances. There are many different types of bikes for different purposes. Some of the most popular bikes are mountain bikes, road bikes, hybrid bikes, and BMX bikes.",
    "Tired of the same old boring phone cases? Upgrade your phone with a new, stylish and fun case from the Fun and Functional case collection. These cases are made from durable, high-quality materials that are sure to protect your phone from bumps and scratches. They are also slim and lightweight, making them easy to take with you on the go. With so many great options to choose from, you're sure to find the perfect case for you."
  ];
  int i = 0;
  int prog = 0;
  bool start =false;

  // This function is triggered when the floating button is pressed
  Future _loadCSV() async {
    try {
      loaded = true;
      setState(() {});
      await rootBundle.loadString("assets/train.csv").then((value) {
        loaded = false;
        List<List<dynamic>> _listData =
            const CsvToListConverter().convert(value);
        // _listData.first.forEach((element) {
        //
        //     _data.add({"Product_Name": name[0] ,"Product_Url": element[]});
        //
        //
        // });
        for (int proDcutUrl = 0;
            _listData.first.length > proDcutUrl;
            proDcutUrl++) {
          if (_listData.first[proDcutUrl + proDcutUrl + 1] != "None") {
            _data.add({
              "Product_Name": name[random.nextInt(10)],
              "Product_Url": _listData.first[proDcutUrl + proDcutUrl + 1],
              "Product_Rating": rating[random.nextInt(4)],
              "Product_Description": Descrption[random.nextInt(2)]
            });
            //         _data.add({"Product_Name": name[0] ,"Product_Url": _listData.first[proDcutUrl+proDcutUrl+1],"Product_Rating":rating[rating.length-1],"Product_Description":Descrption[Descrption.length-1]});

            // print();

          }
          // for(int ratings = 0; rating.length <= ratings;ratings ++){
          // }
        }
      });
      loaded = false;
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    print("hai");
    _loadCSV().whenComplete(() {
      if (_data.isNotEmpty) {
        print("Csv Loaded");
      } else {
        print("error");
      }
    });
    // TODO: implement initState
    @override
    void initState() {
      super.initState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the contents from the CSV file
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              start ? CircularProgressIndicator(color: Color.fromARGB(255, 76, 160, 108),): MaterialButton(
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),

        ),),
              color :  Color(0xfff6497b1),
                  onPressed: () {
                    setState(() {
                      start = true;
                    });
                    _loadData().whenComplete(() {
                      start =false;
                      setState(() {

                      });
                     Navigator.push(context, MaterialPageRoute(builder: (context){
                       return ShowData();
                     }));

                    });
                  },
                  child: Stack(
                    children: [
                      Text("Store Listing" ,textAlign: TextAlign.center, style: TextStyle( letterSpacing: 2, fontSize: 18,fontWeight: FontWeight.w500 ,color: Colors.white) ,),

                    ],
                  ),
                ),
               
              ]
            ),
          ),
        ),
      ),
    );
  }

  Future _loadData() async {
  await  FirebaseFirestore.instance.collection('productData').get().then((snapshot) {
     if(snapshot.docs.isEmpty){
        i = 1;
        _data.forEach((element) {
          try {
            if (i < 1000) {
              FirebaseFirestore.instance.collection("productData").doc().set({
                "ProductName": element["Product_Name"],
                "ProductImage": element["Product_Url"],
                "ProductRating": element["Product_Rating"],
                "ProductDescription": element["Product_Description"]
              });
              setState(() {
                i++;
              });

            }
          } catch (e) {
            print(e);
          }
        });
      }
    });

    //
    //

    setState(() {});
  }
}
