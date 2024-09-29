import 'package:astrology_app/components/custom_app_bar.dart';
import 'package:astrology_app/components/custom_app_drawer.dart';
import 'package:astrology_app/components/custom_navigation_bar.dart';
import 'package:astrology_app/constants/index.dart';
import 'package:astrology_app/screens/call_logs/cubits/call_logs_cubit.dart';
import 'package:astrology_app/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({super.key});

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CallLogsCubit>().loadCallLogs();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      appBar: const CustomAppBar(),
      drawer: const CustomAppDrawer(),
      body: BlocBuilder<CallLogsCubit, CallLogsState>(
        builder: (context, state) {
          if (state is CallLogsLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blue.shade900),
            );
          } else if (state is CallLogsLoaded) {
            final callFutures = state.callLogs;
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FutureBuilder(
                future: Future.wait(callFutures),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Something went wrong, Please try again'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No calls available'));
                  }

                  final data = snapshot.data!; // List of CallLogs
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      if (data.isNotEmpty) {
                        final callLog = data[index];
                        final isVideo =
                            callLog.callType == "video" ? true : false;
                        final isMissed = callLog.duration == "00:00";
                        // final
                        return GestureDetector(
                          onTap: () => {},
                          child: _callContainer(
                            size,
                            callLog.caller,
                            formatTimestamp(callLog.createdAt, true),
                            callLog.duration,
                            // "25",
                            isVideo,
                            isMissed,
                          ),
                        );
                      }
                      return null;
                    },
                  );
                },
              ),
            );
          } else if (state is CallLogsError) {
            return const Center(
              child: Text('Something went wrong, Please try again'),
            );
          } else {
            return const Center(child: Text('No calls available'));
          }
        },
      ),
    );
  }
}

Widget _callContainer(
  Size size,
  String userName,
  String date,
  String duration,
  // String amount,
  bool isVideo,
  bool isMissed,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.65,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    isVideo
                        ? Icons.videocam_outlined
                        : Icons.phone_outlined,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: date,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          const TextSpan(text: "  "),
                          TextSpan(
                            text: "Duration: $duration",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // _amountTransaction(size, true, amount),
        ],
      ),
    ),
  );
}

Widget _amountTransaction(Size size, bool add, String amount) {
  return Text(
    "${add ? "+" : "-"} $amount.00 INR",
    style: TextStyle(
        color: add ? Colors.green.shade400 : Colors.red.shade400,
        fontWeight: FontWeight.w500,
        fontSize: size.height * 0.018),
  );
}
