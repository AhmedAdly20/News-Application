import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_application/helper/data.dart';
import 'package:news_application/helper/widgets.dart';
import 'package:news_application/models/article.dart';
import 'package:news_application/models/category.dart';
import 'package:news_application/helper/news.dart';
import 'package:news_application/views/category_news.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  List<Article> newslist;
  List<CategoryModel> categories = new List<CategoryModel>();

  getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    categories = getCategoryies();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text(
              'News',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: Container(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            categoryName: categories[index].categoryName,
                            imageUrl: categories[index].imageUrl,
                          );
                        },
                      ),
                    ),
                    // headline news
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        itemCount: newslist.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return NewsTile(
                            imgUrl: newslist[index].urlToImage ?? "",
                            title: newslist[index].title ?? "",
                            desc: newslist[index].description ?? "",
                            content: newslist[index].content ?? "",
                            posturl: newslist[index].articleUrl ?? "",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  final imageUrl, categoryName;

  const CategoryTile({Key key, this.imageUrl, this.categoryName});
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryNews(
              newsCategory: categoryName.toLowerCase(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120.0,
                  height: 60.0,
                  fit: BoxFit.cover),
            ),
            Container(
              alignment: Alignment.center,
              width: 120.0,
              height: 60.0,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(6.0)),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
