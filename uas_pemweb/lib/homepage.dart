import 'package:flutter/material.dart';
import '../imagepage.dart';
import '../views/categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  int index_size = 0;
  var _kategory = ['Alam', 'Hot', 'Game', 'Sexy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallpaper App',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: PageView.builder(
                  itemCount: 10,
                  controller:
                      PageController(viewportFraction: 0.5, initialPage: 3),
                  // onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) {
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: _index == index
                          ? EdgeInsets.only()
                          : EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: () {
                          print('Card di tekan pada indeks $index');
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  child: Center(child: Text('Wallpaper')),
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Text at the bottom',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategorieTile(
                    title: categories[index].categorieName,
                    imgUrl: categories[index].imgUrl,
                  );
                },
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Display(),
        ),
      ),
    );
  }
}
