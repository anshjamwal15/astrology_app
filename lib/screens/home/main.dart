import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      backgroundColor: AppConstants.bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.04,
          horizontal: size.width * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello, Rohit",
              style: TextStyle(
                color: Colors.black45,
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "Let's Discuss",
              style: TextStyle(
                color: Colors.black,
                fontSize: size.height * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              children: [
                // SizedBox(
                //   height: size.height * 0.26,
                //   width: size.width * 0.45,
                //   child: Container(
                //     height: size.height * 0.26,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       image: DecorationImage(
                //         image: AssetImage("assets/images/business_support.jpg"),
                //         fit: BoxFit.cover,
                //         colorFilter: ColorFilter.mode(
                //           Colors.black.withOpacity(0.2),
                //           BlendMode.darken,
                //         ),
                //       ),
                //     ),
                //     child: Stack(
                //       children: [
                //         Positioned.fill(
                //           child: Container(
                //             decoration: BoxDecoration(
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(20)),
                //               gradient: LinearGradient(
                //                 colors: [
                //                   Colors.black54,
                //                   Colors.transparent,
                //                   Colors.transparent,
                //                   Colors.black54
                //                 ],
                //                 begin: Alignment.topCenter,
                //                 end: Alignment.bottomCenter,
                //                 stops: [0, 0, 0.4, 1],
                //               ),
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(top: 150, left: 10),
                //           child: Text(
                //             "Business support",
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: size.height * 0.028,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: Container(
                    height: size.height * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: const AssetImage(
                          "assets/images/business_support.jpg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Text(
                        "Business Support",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: Container(
                    height: size.height * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: const AssetImage(
                          "assets/images/prof_skills.jpg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Text(
                        "Professional Skills",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: Container(
                    height: size.height * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: const AssetImage(
                          "assets/images/points.jpg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Text(
                        "Personal Points",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: Container(
                    height: size.height * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: const AssetImage(
                          "assets/images/academic.jpg",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.4),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Text(
                        "Academic Issues",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}

/* 
  NavigationBar(
            shadowColor: Colors.black,
            backgroundColor: Colors.white,
            destinations: [
              Container(
                height: size.height * 0.08,
                width: double.maxFinite,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.home),
                    ),
                    Text("Home")
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_rounded),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.meeting_room),
              ),
            ],
          )
*/