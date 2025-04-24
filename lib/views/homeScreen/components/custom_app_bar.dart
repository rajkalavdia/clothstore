import 'package:clotstoreapp/backend/provider/userProvider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserProvider? userProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      child: Column(
        children: [
          getHeaderWidget(),
        ],
      ),
    );
  }

  Widget getHeaderWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/ProfileScreen');
          },
          child: (userProvider?.user?.imageUrl != null)
              ? Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userProvider!.user!.imageUrl!,
                      fit: BoxFit.cover,
                      height: 55,
                    ),
                  ),
                )
              : Image.asset(
                  'asset/images/profile_picture.png',
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
        ),
        Container(
          height: 55,
          width: 55,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/CartProductList',
              );
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
}
