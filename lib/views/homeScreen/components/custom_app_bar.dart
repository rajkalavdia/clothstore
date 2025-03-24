import 'package:flutter/material.dart';
class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: 170,
          child: Column(
            children: [
              getHeaderWidget(),
              getTextfieldWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeaderWidget(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/ProfileScreen');
          },
          child: Container(
            height: 55,
            width: 55,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: AssetImage(
                  'asset/images/profile_picture.jpg',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        Container(
          height: 55,
          width: 55,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.deepPurpleAccent, borderRadius: BorderRadius.circular(40)),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/CartProductList',);
            },
            icon: Image.asset(
              'asset/icons/bag2.png',
              height: 25,
            ),
          ),
        )
      ],
    );
  }

  Widget getTextfieldWidget(){
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, "/SearchScreen");
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              'asset/icons/searchButton.png',
              height: 25,
              width: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Search',
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
