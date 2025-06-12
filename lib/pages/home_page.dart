import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/circular_stat.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVideoFromFirestore();
  }

Future<void> _loadVideoFromFirestore() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    // Fetch the most recent video for the user based on uploadedAt
    final snapshot = await FirebaseFirestore.instance
        .collection('videos')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty || snapshot.docs.first.data()['path'] == null) {
      throw Exception('No uploaded video found for this user.');
    }

    final videoUrl = snapshot.docs.first.data()['path'].toString();

    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() => _isInitialized = true);
        _controller.play();
        _controller.setLooping(true);
      });
  } catch (e) {
    setState(() {
      _error = 'Failed to load video: $e';
    });
  }
}

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black12,
                ),
                child: _error != null
                    ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                    : !_isInitialized
                        ? const Center(child: CircularProgressIndicator())
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  VideoPlayer(_controller),
                                  VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.all(8),
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.blue,
                                      bufferedColor: Colors.grey,
                                      backgroundColor: Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),

              const SizedBox(height: 12),

              if (_isInitialized)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 36,
                      color: Colors.blue,
                      onPressed: _togglePlayPause,
                    ),
                  ],
                ),

              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircularStat(label: "Shots Played", value: "100", color: Colors.blue),
                  CircularStat(label: "Ball Hitting", value: "89%", color: Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Coming Soon"),
                      content: const Text("This feature is coming soon in Milestone 3."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Show Detail Analytics",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
