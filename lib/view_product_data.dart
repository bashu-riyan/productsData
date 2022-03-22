import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage_2/provider.dart';
import 'package:flutter_advanced_networkimage_2/transition.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:prapp/modal/ProductsData.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);


  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {


  QuerySnapshot<Map>?  image;
 bool loading = false;
Future LoadData() async {
  setState(() {
    loading = true;

  });
  FirebaseFirestore.instance.collection("productData").orderBy("ProductName").get().then(( value) {
    setState(() {
      image =  value;
    });
  });


  await Future.wait(  image!.docs.map((prductData) => prductData["ProductImage"]));

  await Future.delayed(Duration(seconds: 1),(){});
setState(() {
  loading = false;
});
}
@override
  void initState() {

  // WidgetsBinding.instance!.addPersistentFrameCallback((_) => LoadData());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(10),
    ),),
        backgroundColor: Color(0xfff6497b1),
       title : Text("Products Data")
      ),

      body: SafeArea(

        child: Container(
          color: Colors.grey[40],
          child: PaginateFirestore(
            itemBuilder: (context, documentSnapshots, index) {

              return     Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(

                  decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: 60,
                  child: FlipCard(
                    fill: Fill
                        .fillBack, // Fill the back side of the card to make in the same size as the front.
                    direction: FlipDirection.VERTICAL, // default
                    front: Container(
                        // padding: EdgeInsets.all(4),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                          Container(
                            child: TransitionToImage(
                              borderRadius: BorderRadius.circular(10),
                              width:MediaQuery.of(context).size.width*0.6,
                              height: MediaQuery.of(context).size.height*0.2,
                          duration: Duration(milliseconds: 300),
                              image: AdvancedNetworkImage(documentSnapshots[index]["ProductImage"],
                                  useDiskCache: true,
                                cacheRule: CacheRule(maxAge: const Duration(days: 7)),

                              ),
                            placeholderBuilder: (failed  ,_){
                            return Container(
                              width:MediaQuery.of(context).size.width*0.6,
                              height: MediaQuery.of(context).size.height*0.2,
                              child: Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Invalid Url can't load Image" ,style: TextStyle(fontWeight: FontWeight.bold),),
                                  Icon(Icons.sms_failed_sharp ,size: 40,)
                                ],
                              )),
                            );
                            },
                              imageFilter: ImageFilter.blur(),
                              loadingWidgetBuilder: (_, double progress, __) =>  Container(
                                  width:MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.2,
                                  child: Image.asset("assets/animation.gif" ,width: 50,)),
                              // placeholder:
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0,bottom: 4,left: 4),
                            child: Row(
                              children: [
                                Text(
                                  "Product Name : ",
                                  style: TextStyle( letterSpacing: 1,fontWeight: FontWeight.bold),
                                ),
                                Text(" ${documentSnapshots[index]['ProductName']}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                },
                                starCount: 5,
                                rating: int.parse(documentSnapshots[index]["ProductRating"].toString()).toDouble(),
                                size: 20.0,
                                isReadOnly:true,

                                color: Colors.yellow,
                                borderColor: Colors.brown,
                                spacing:0.0
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(4.0),
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Description : ", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${documentSnapshots[index]["ProductDescription"].toString().substring(0,13)}.. ",softWrap: true,maxLines: 2,),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("show more" ,style: TextStyle(color: Colors.grey),),
                          ),
                        ])),
                    back: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Description : ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              documentSnapshots[index]
                              ['ProductDescription'].toString().substring(0, 300),
                          textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },

            // orderBy is compulsary to enable pagination
            query: FirebaseFirestore.instance
                .collection("productData")
                .orderBy('ProductName'),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 290,
              crossAxisCount: 2,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 10.0,
            ),
            itemBuilderType: PaginateBuilderType.gridView,
          ),
        ),
      ),
    );
  }
}
