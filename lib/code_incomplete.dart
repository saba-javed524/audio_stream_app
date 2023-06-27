// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// const appId = 'c60365748fe24e8f9011b0a8e6fddc3f';

// void main() {
//   runApp(MaterialApp(
//     home: VoiceChatApp(),
//   ));
// }

// class VoiceChannel {
//   final String name;
//   final List<String> participants;

//   VoiceChannel(this.name, this.participants);
// }

// class VoiceChatApp extends StatefulWidget {
//   @override
//   _VoiceChatAppState createState() => _VoiceChatAppState();
// }

// class _VoiceChatAppState extends State<VoiceChatApp> {
//   bool _localUserJoined = false;
//   List<VoiceChannel> voiceChannels = [
//     VoiceChannel('Channel 1', []),
//     VoiceChannel('Channel 2', []),
//     VoiceChannel('Channel 3', []),
//   ];
//   List<String> participants = [];
//   bool isMuted = false;
//   double volumeLevel = 1.0;
//   RtcEngine? _rtcEngine;

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   Future<void> initialize() async {
//     // retrieve permissions
//     await [Permission.microphone, Permission.camera].request();

//     // //create the engine
//     //create the engine
//     _rtcEngine = createAgoraRtcEngine();
//      await _rtcEngine?.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//     ));
 
//     // Enable audio
//     await _rtcEngine!.enableAudio();
//     // Set up audio callbacks

//      _rtcEngine?.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             _localUserJoined = true;
//           });
    
//   }

//   Future<void> _handleCameraAndMicPermissions() async {
//     await PermissionHandler().requestPermissions(
//       [Permission.camera, Permission.microphone],
//     );
//   }

//   Future<void> _joinChannelWithAudio(String channelName) async {
//     await _handleCameraAndMicPermissions();

//     // Join the channel
//     await _rtcEngine!.joinChannel(null, channelName, null, 0);
//   }

//   Future<void> _leaveChannel() async {
//     // Leave the channel
//     await _rtcEngine!.leaveChannel();
//     setState(() {
//       participants.clear();
//     });
//   }

//   Widget _buildChannelsList() {
//     return ListView.builder(
//       itemCount: voiceChannels.length,
//       itemBuilder: (context, index) {
//         final channel = voiceChannels[index];
//         return ListTile(
//           title: Text(channel.name),
//           subtitle: Text('${channel.participants.length} Participants'),
//           onTap: () {
//             _joinChannelWithAudio(channel.name);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => VoiceChatScreen(
//                   rtcEngine: _rtcEngine!,
//                   channelName: channel.name,
//                   participants: channel.participants,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Voice Chat App'),
//       ),
//       body: Center(
//         child: _buildChannelsList(),
//       ),
//     );
//   }
// }

// class VoiceChatScreen extends StatefulWidget {
//   final RtcEngine rtcEngine;
//   final String channelName;
//   final List<String> participants;

//   const VoiceChatScreen({
//     required this.rtcEngine,
//     required this.channelName,
//     required this.participants,
//   });

//   @override
//   _VoiceChatScreenState createState() => _VoiceChatScreenState();
// }

// class _VoiceChatScreenState extends State<VoiceChatScreen> {
//   bool isMuted = false;
//   double volumeLevel = 1.0;

//   void _toggleMute() {
//     setState(() {
//       isMuted = !isMuted;
//       widget.rtcEngine.muteLocalAudioStream(isMuted);
//     });
//   }

//   void _adjustVolume(double value) {
//     setState(() {
//       volumeLevel = value;
//       widget.rtcEngine.adjustAudioMixingVolume(value.toInt());
//     });
//   }

//   Widget _buildParticipantsList() {
//     return ListView.builder(
//       itemCount: widget.participants.length,
//       itemBuilder: (context, index) {
//         final participant = widget.participants[index];
//         return ListTile(
//           title: Text(participant),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.channelName),
//         actions: [
//           IconButton(
//             onPressed: _toggleMute,
//             icon: Icon(isMuted ? Icons.mic_off : Icons.mic),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildParticipantsList(),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Slider(
//               value: volumeLevel,
//               min: 0.0,
//               max: 100.0,
//               divisions: 100,
//               onChanged: _adjustVolume,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           widget.rtcEngine.leaveChannel();
//           Navigator.pop(context);
//         },
//         child: Icon(Icons.call_end),
//       ),
//     );
//   }
// }