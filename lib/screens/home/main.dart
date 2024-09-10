import 'package:astrology_app/blocs/chat/chat_bloc.dart';
import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as model;
import 'package:astrology_app/screens/support/cubits/mentor_cubit.dart';
import 'package:astrology_app/screens/support/main.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final model.User user;

  @override
  void initState() {
    super.initState();
    user = UserManager.instance.user!;
    context.read<ChatBloc>().add(GetUnreadCount(user.id));
  }

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
              "Hello, ${user.name.isEmpty == true ? "User" : user.name}",
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
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                MentorCubit(FirebaseFirestore.instance),
                            child: const SupportScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.26,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                ),
                SizedBox(width: size.width * 0.02),
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                MentorCubit(FirebaseFirestore.instance),
                            child: const SupportScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.26,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                MentorCubit(FirebaseFirestore.instance),
                            child: const SupportScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.26,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
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
                ),
                SizedBox(width: size.width * 0.02),
                SizedBox(
                  height: size.height * 0.26,
                  width: size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                MentorCubit(FirebaseFirestore.instance),
                            child: const SupportScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: size.height * 0.26,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
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
