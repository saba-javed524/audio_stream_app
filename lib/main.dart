import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: VoiceChatApp(),
  ));
}

class VoiceChannel {
  final String name;
  final List<String> participants;

  VoiceChannel(this.name, this.participants);
}

class VoiceChatApp extends StatefulWidget {
  const VoiceChatApp({super.key});

  @override
  _VoiceChatAppState createState() => _VoiceChatAppState();
}

class _VoiceChatAppState extends State<VoiceChatApp> {
  List<VoiceChannel> voiceChannels = [];
  List<String> participants = [];
  bool isMuted = false;
  double volumeLevel = 1.0;

  void _createChannel() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String channelName = '';

        return AlertDialog(
          title: const Text('Create New Channel'),
          content: TextField(
            onChanged: (value) {
              channelName = value;
            },
            decoration: const InputDecoration(hintText: 'Enter Channel Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  voiceChannels.add(VoiceChannel(channelName, []));
                });
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _joinChannel(int index) {
    final channel = voiceChannels[index];
    if (channel.participants.contains('YOU')) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Leave Channel'),
            content: Text('Are you sure you want to leave ${channel.name}?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    voiceChannels[index].participants.remove('YOU');
                  });
                  Navigator.pop(context);
                },
                child: Text('Leave'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Join Channel'),
            content: Text('Are you sure you want to join ${channel.name}?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    voiceChannels[index].participants.add('YOU');
                  });
                  Navigator.pop(context);
                },
                child: Text('Join'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Chat'),
      ),
      body: ListView.builder(
        itemCount: voiceChannels.length,
        itemBuilder: (context, index) {
          final channel = voiceChannels[index];
          return ListTile(
            title: Text(channel.name),
            subtitle: Text('Participants: ${channel.participants.length}'),
            onTap: () => _joinChannel(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createChannel,
        child: const Icon(Icons.add),
      ),
    );
  }
}
