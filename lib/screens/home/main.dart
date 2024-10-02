import 'package:astrology_app/blocs/index.dart';
import 'package:astrology_app/components/index.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/models/index.dart' as model;
import 'package:astrology_app/screens/home/cubits/home_cubit.dart';
import 'package:astrology_app/screens/support/cubits/mentor_cubit.dart';
import 'package:astrology_app/screens/support/main.dart';
import 'package:astrology_app/services/user_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

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
    user = context.read<AppBloc>().state.user;
    UserManager.instance.loadUser();
    context.read<ChatBloc>().add(GetUnreadCount(user.id));
    context.read<UserBloc>().add(UserWalletRequest(user.id));
    context.read<HomeCubit>().loadCategories();
    _requestPermissions();
  }

  void _requestPermissions() async {
    await [Permission.notification, Permission.camera, Permission.microphone].request();
  }

  Future<void> _pullRefresh() async {
    context.read<ChatBloc>().add(GetUnreadCount(user.id));
    context.read<UserBloc>().add(UserWalletRequest(user.id));
    context.read<HomeCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      backgroundColor: AppConstants.bgColor,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        color: Colors.blue.shade900,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
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
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is CategoriesLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: Colors.blue.shade900),
                      );
                    } else if (state is CategoriesLoaded) {
                      final categories = state.categories;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.02,
                          mainAxisSpacing: size.height * 0.02,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return buildItem(context, size,
                              image: category.image, title: category.name);
                        },
                      );
                    } else if (state is CategoriesError) {
                      return const Center(
                          child: Text('Something went wrong, Please try again'));
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, Size size,
      {required String image, required String title}) {
    return SizedBox(
      // height: size.height * 0.1,
      width: size.width * 0.45,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => MentorCubit(),
                child: const SupportScreen(),
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 400),
          imageUrl: image,
          errorWidget: (context, url, error) => const Icon(Icons.error),
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Container(
              margin: const EdgeInsets.all(80),
              child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: Colors.blue.shade900),
            );
          },
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: imageProvider,
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
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
