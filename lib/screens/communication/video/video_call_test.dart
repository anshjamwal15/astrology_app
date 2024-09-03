// import 'package:astrology_app/services/video_signaling_service.dart';
// import 'package:astrology_app/services/user_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// class VideoCallTest extends StatefulWidget {
//   const VideoCallTest({super.key});
//
//   @override
//   State<VideoCallTest> createState() => _VideoCallTestState();
// }
//
// class _VideoCallTestState extends State<VideoCallTest> {
//   VideoSignalingService signaling = VideoSignalingService();
//   final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
//   final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
//   String? roomId;
//   TextEditingController textEditingController = TextEditingController(text: '');
//
//   @override
//   void initState() {
//     _localRenderer.initialize();
//     _remoteRenderer.initialize();
//     signaling.onAddRemoteStream = ((stream) {
//       setState(() {
//         _remoteRenderer.srcObject = stream;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _localRenderer.dispose();
//     _remoteRenderer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Video call test"),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     await signaling.openUserMedia(_localRenderer, _remoteRenderer);
//                   },
//                   child: const Text("Open"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     roomId = await signaling.createRoom(UserManager.instance.user!.id, _remoteRenderer);
//                     textEditingController.text = roomId!;
//                     setState(() {});
//                   },
//                   child: const Text("Create"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await signaling.joinRoom(
//                       textEditingController.text.trim(),
//                       _remoteRenderer,
//                     );
//                   },
//                   child: const Text("Join"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     signaling.hangUp(textEditingController.text ,_localRenderer);
//                   },
//                   child: const Text("End"),
//                 )
//               ],
//             ),
//           ),
//           Column(
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 child: RTCVideoView(_localRenderer, mirror: true),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 child: RTCVideoView(_remoteRenderer),
//               )
//             ],
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Join the following Room: "),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.5,
//               child: TextFormField(
//                 controller: textEditingController,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
