import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:foodappmajd/main.dart' as main1;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return new MaterialApp(
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getData() async {
    final response =
        await http.get("http://majd1997.000webhostapp.com/foodapp/getdata.php");

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new FutureBuilder<List<dynamic>>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Container(height: double.infinity,width: double.infinity,
                child: Image.asset('assets/loading.gif',fit: BoxFit.cover,));
          }),
    );
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;
  SelectedPhoto({this.photoIndex, this.numberOfDots});

  Widget _inactivePhoto() {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(4.0)),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return new Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
              ]),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }
    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDots(),
    );
  }
}

class ItemList extends StatefulWidget {
  final List<dynamic> list;

  const ItemList({Key key, this.list}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  int photoIndex = 0;

  List<String> photos = new List<String>();
  List<String> companyName = new List<String>();
  List<String> companyDetails = new List<String>();

  List<int> cId = new List<int>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.list.length; i++) {
      photos.add(widget.list[i]['pic']);
      companyName.add(widget.list[i]['name']);
      companyDetails.add(widget.list[i]['details']);
      cId.add(int.parse(widget.list[i]['id']));

      // print(widget.list);
    }
    print(photos);
    print(cId);

    print(companyName);
    print(companyDetails);
  }

  Future<List> getDataList() async {
    final response = await http
        .get("http://majd1997.000webhostapp.com/foodapp/getdataList.php");

    return json.decode(response.body);
  }

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
      //  main1.aaa=1;
      if (photoIndex >= 0)
        main1.customWidgetKey.currentState.update(cId[photoIndex]);
      print('$photoIndex prev');
      print('${cId[photoIndex]} prev');
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
      // main1.aaa=1;
      if (photoIndex < photos.length)
        main1.customWidgetKey.currentState.update(cId[photoIndex]);
      print('$photoIndex nex');
      print('${cId[photoIndex]} nex');
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height / 3,
                  decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                      image: DecorationImage(
                          image: NetworkImage(photos[photoIndex]),
                          fit: BoxFit.cover)),
                ),
                Container(
                  height: height / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: height / 12),
                    height: height / 3 - height / 12,
                    width: width,
                    color: Colors.transparent,
                  ),
                  onTap: _nextImage,
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: height / 12),
                    height: height / 3 - height / 12,
                    width: width / 2,
                    color: Colors.transparent,
                  ),
                  onTap: _previousImage,
                ),

//                Container(
//
//                  height: height/3,
//                  child: Container(
//
//                    alignment:  Alignment.bottomCenter,
//                    padding: EdgeInsets.only(bottom: 5,left: 20)
//                    ,child:Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.star,
//                        color: Colors.amber,
//                      ),
//                      Icon(
//                        Icons.star,
//                        color: Colors.amber,
//                      ),
//                      Icon(
//                        Icons.star,
//                        color: Colors.amber,
//                      ),
//                      Icon(
//                        Icons.star,
//                        color: Colors.amber,
//                      ),
//                      Icon(
//                        Icons.star,
//                        color: Colors.grey,
//                      ),
//                      SizedBox(width: 2.0,)
//                      ,
//                      Text('4.0',
//                        style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold,
//
//                        ),
//                      )
//                      ,
//                      SizedBox(width: 4.0,),
//
//                    ],
//                  ),
//
//                  ),
//
//                ),
                Container(
                  height: height / 3,
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 10),
                      child: SelectedPhoto(
                        photoIndex: photoIndex,
                        numberOfDots: photos.length,
                      )),
                ),
              ],
            ),
            Container(
              height: height / 6,
              width: width,
              color: Colors.cyan.shade100,
              // padding: EdgeInsets.only(top: 0),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'OPEN NOW UNTIL 11PM',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 100),
                  ),
                  Text(
                    companyName[photoIndex],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 100),
                  ),
                  Text(
                    companyDetails[photoIndex],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.cyan,
              padding: EdgeInsets.only(left: width / 12),
              child: Row(
                children: <Widget>[],
              ),
            ),
            Container(
              height: height / 2,
              color: Colors.cyan.shade50,
              child: FutureBuilder<List<dynamic>>(
                  future: getDataList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new itemsListDetails(
                            key: customWidgetKey,
                            listItems: snapshot.data,
                            id: cId[photoIndex],
                          )
                        : new Center(child: new CircularProgressIndicator());
                  }),
            ),
            //  _buildListItem(photos[0])
          ],
        )
      ],
    );
  }
}

class itemsListDetails extends StatefulWidget {
  final List<dynamic> listItems;
  final int id;

  const itemsListDetails({Key key, this.listItems, this.id}) : super(key: key);

  @override
  _itemsListDetailsState createState() => _itemsListDetailsState();
}

final customWidgetKey = new GlobalKey<_itemsListDetailsState>();

class _itemsListDetailsState extends State<itemsListDetails> {
  int itemIndex = 0;

  List<String> photos = new List<String>();
  List<String> itemName = new List<String>();
  List<String> itemDetails = new List<String>();
  List<String> itemPrice = new List<String>();
  List<int> itemCId = new List<int>();
  List<int> itemId = new List<int>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < widget.listItems.length; i++) {
      if (int.parse(widget.listItems[i]['company_id']) == widget.id) {
        photos.add(widget.listItems[i]['pic']);
        itemName.add(widget.listItems[i]['name']);
        itemDetails.add(widget.listItems[i]['details']);
        itemPrice.add(widget.listItems[i]['price']);
        itemCId.add(int.parse(widget.listItems[i]['company_id']));
        itemId.add(int.parse(widget.listItems[i]['id']));
      }
      // print(widget.list);
    }

    print(photos);
    print(itemCId);
    print(itemName);
    print(itemDetails);
    print(itemPrice);
  }

  void update(int idd) {
    photos.clear();
    itemName.clear();
    itemPrice.clear();
    itemDetails.clear();
    itemCId.clear();
    itemId.clear();

    for (int i = 0; i < widget.listItems.length; i++) {
      if (int.parse(widget.listItems[i]['company_id']) == idd) {
        photos.add(widget.listItems[i]['pic']);
        itemName.add(widget.listItems[i]['name']);
        itemDetails.add(widget.listItems[i]['details']);
        itemPrice.add(widget.listItems[i]['price']);
        itemCId.add(int.parse(widget.listItems[i]['company_id']));
        itemId.add(int.parse(widget.listItems[i]['id']));
      }
      // print(widget.list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.listItems == null ? 0 : photos.length,
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.all(3.0),
          child: Container(
            child: _buildListItem(i),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.lightBlueAccent, Colors.cyan]),
                borderRadius: BorderRadius.circular(20.0)),
          ),
        );
      },
    );
  }

  Widget _buildListItem(int index) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    //    Padding(padding: EdgeInsets.only(top: 5),),

                    Text(
                      itemName[index],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    //    Padding(padding: EdgeInsets.only(top: 10),),

                    Text(
                      itemDetails[index],
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15.0),
                    ),
                    //   Padding(padding: EdgeInsets.only(top:10),),

                    Text(
                      itemPrice[index],
                      textDirection: TextDirection.rtl,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () => _showSecondPage(context,photos[index],itemCId[index]),
                child: Hero(
                  tag: 'my-hero-animation-tag ${itemId[index]}',
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    height: MediaQuery.of(context).size.height / 7,
                    width: MediaQuery.of(context).size.height / 7,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(photos[index]),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }


}

void _showSecondPage(BuildContext context,String url,int id) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (ctx) => Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GestureDetector(
          onTap: Navigator.of(ctx).pop,
          child: Container(
            color: Colors.transparent,
            child: Hero(

              tag: 'my-hero-animation-tag ${id}',
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.contain),
              ),
            ),
      ),
          ),
        ),
    ),
  )
  )
  );
}